#!/bin/bash
#SBATCH --job-name=BigDataMiningP1Q2_bigdata_pipeline
#SBATCH --output=bigdata_pipeline.out
#SBATCH --error=bigdata_pipeline.err
#SBATCH --time=2:00:00
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4

DATA_DIR="Data"
mkdir -p "$DATA_DIR"
OrZukData="/sci/home/orzuk/BigDataMiningExam"
REVIEW_FILE="$OrZukData/review-Oregon.json.gz"
META_FILE="$OrZukData/meta-Oregon.json.gz"
STEP_2_PYTHON_SCRIPT="First.py"
STEP_3_PYTHON_SCRIPT="Second.py"
FINAL_OUTPUT="$DATA_DIR/final_results.csv"

wait_for_jobs() {
    local job_ids=($1)  # Convert job IDs to an array
    local step_name=$2
    local start_time=$(date +%s)

    echo -n "⏳ Waiting for $step_name to complete... (00:00:00)"
    
    while true; do
        all_completed=true  # Assume all jobs are done unless proven otherwise
        sleep 1  # Check every 1 second

        for job_id in "${job_ids[@]}"; do
            # Check if the job is still running
            if squeue -j "$job_id" | grep -q "$job_id"; then
                all_completed=false  # At least one job is still running
                break
            fi

            # If job is not in squeue, check its historical status in sacct
            job_status=$(sacct -j "$job_id" --format=State --noheader | awk '{print $1}' | sort | uniq)

            if [[ "$job_status" =~ "FAILED|CANCELLED|TIMEOUT" ]]; then
                echo -e "\n❌ $step_name failed. Job ID: $job_id, Status: $job_status"
                exit 1
            elif [[ "$job_status" == "COMPLETED" ]]; then
                continue  # Job is done, check the next one
            elif [[ -z "$job_status" ]]; then
                echo -e "\n⚠️  Warning: Job ID $job_id not found in SLURM history. Assuming completed."
            else
                all_completed=false  # Job status is unclear, so keep waiting
                break
            fi
        done

        # If all jobs are completed, exit the loop
        if $all_completed; then
            break
        fi

        # Update elapsed time dynamically
        current_time=$(date +%s)
        elapsed=$((current_time - start_time))
        hours=$((elapsed / 3600))
        minutes=$(((elapsed % 3600) / 60))
        seconds=$((elapsed % 60))
        printf "\r⏳ Waiting for $step_name to complete... (%02d:%02d:%02d)" $hours $minutes $seconds
    done

    # Final message
    printf "\r✅ $step_name completed in (%02d:%02d:%02d)\n" $hours $minutes $seconds
}

echo "🚀 Submitting SLURM Jobs for Optimized Pipeline..."

# ===================== STEP 1: SPLIT REVIEWS (PARALLEL JOBS) =====================
echo "📂 Submitting Step 1: Splitting reviews into parallel jobs..."

STEP1_JOB_IDS=()
for i in {1..5}; do
    STEP1_JOB=$(sbatch --parsable <<EOF
#!/bin/bash
#SBATCH --job-name=BigDataMiningP1Q2_split_rating_$i
#SBATCH --output=split_rating_$i.out
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1

output_file="$DATA_DIR/rating_$i.txt"
echo "user_id,rating,gmap_id" > "\$output_file"

zcat "$REVIEW_FILE" | jq --argjson i "$i" -r 'select(.rating == $i) | [.user_id, .rating, .gmap_id] | @csv' >> "\$output_file"

echo "✅ Created \$output_file with \$(wc -l < "\$output_file") lines."
EOF
)
    STEP1_JOB_IDS+=("$STEP1_JOB")
done

echo "📊 Step 1 Jobs Submitted: ${STEP1_JOB_IDS[*]}"

DEPENDENCY_STEP1=$(IFS=,; echo "${STEP1_JOB_IDS[*]}")

# ===================== WAIT FOR STEP 1 TO FINISH =====================
wait_for_jobs "$DEPENDENCY_STEP1" "Step 1 (Splitting Reviews)"

# ===================== STEP 2: COUNT gmap_id (PARALLEL JOBS) =====================
echo "📂 Submitting Step 2: Counting gmap_id occurrences..."

STEP2_JOB_IDS=()
for i in {1..5}; do
    STEP2_JOB=$(sbatch --parsable --dependency=afterok:$DEPENDENCY_STEP1 <<EOF
#!/bin/bash
#SBATCH --job-name=BigDataMiningP1Q2_count_rating_$i
#SBATCH --output=count_rating_$i.out
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1

input_file="$DATA_DIR/rating_$i.txt"
output_file="$DATA_DIR/rating_${i}_counts.txt"

if [ -s "\$input_file" ]; then
    python3 "$STEP_2_PYTHON_SCRIPT" "\$input_file" "\$output_file"

    if [ -s "\$output_file" ]; then
        echo "✅ Created \$output_file with \$(wc -l < "\$output_file") lines."
    else
        echo "❌ Error: Output file \$output_file was not created."
    fi
else
    echo "⚠️ Skipping empty file: \$input_file"
fi
EOF
)
    STEP2_JOB_IDS+=("$STEP2_JOB")
done

echo "📊 Step 2 Jobs Submitted: ${STEP2_JOB_IDS[*]}"

DEPENDENCY_STEP2=$(IFS=,; echo "${STEP2_JOB_IDS[*]}")

# ===================== WAIT FOR STEP 2 TO FINISH =====================
wait_for_jobs "$DEPENDENCY_STEP2" "Step 2 (Counting gmap_id)"

# ===================== STEP 3: AGGREGATE RESULTS =====================
echo "📂 Submitting Step 3: Aggregating final results..."

STEP3_JOB=$(sbatch --parsable --dependency=afterok:$DEPENDENCY_STEP2 <<EOF
#!/bin/bash
#SBATCH --job-name=BigDataMiningP1Q2_aggregate_results
#SBATCH --output=aggregate_results.out
#SBATCH --mem=8G
#SBATCH --cpus-per-task=2

zcat "$META_FILE" | python3 "$STEP_3_PYTHON_SCRIPT" "$DATA_DIR" "/dev/stdin" "$FINAL_OUTPUT"

if [ -s "$FINAL_OUTPUT" ]; then
    echo "✅ Step 3 completed successfully. Final results saved in $FINAL_OUTPUT"
else
    echo "❌ Step 3 failed. No output file generated."
    exit 1
fi
EOF
)

echo "📊 Step 3 Jobs Submitted: $STEP3_JOB"

# ===================== WAIT FOR STEP 3 TO FINISH =====================
wait_for_jobs "$STEP3_JOB" "Step 3 (Aggregation)"

# ===================== PRINT TOP 3 BUSINESSES =====================
if [ -s "$FINAL_OUTPUT" ]; then
    echo "✅ Aggregation complete. Displaying top 3 businesses from $FINAL_OUTPUT"

    echo ""
    echo "🏆 Top 3 Businesses:"
    echo "--------------------------"
    head -n 4 "$FINAL_OUTPUT" | tail -n 3 | column -t -s ","
    echo "--------------------------"
else
    echo "❌ Error: Aggregation failed or output file is empty."
fi

echo "✅ Optimized SLURM Pipeline Completed Successfully."
