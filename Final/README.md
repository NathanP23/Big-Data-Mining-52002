FINAL/
│── First.py                 # Python script for counting gmap_id occurrences per rating
│── Second.py                # Python script for aggregating results and mapping names
│── main_bash.sh             # Bash script to run the pipeline using SLURM on Moriah
│
├── Data/                    # Directory containing all data files
│   │── review-Oregon.json       # Original dataset with all reviews
│   │── meta-Oregon.json         # Metadata file mapping gmap_id to business names
│   │
│   │── rating_1.txt             # Reviews with rating = 1 (generated in Step 1)
│   │── rating_2.txt             # Reviews with rating = 2
│   │── rating_3.txt             # Reviews with rating = 3
│   │── rating_4.txt             # Reviews with rating = 4
│   │── rating_5.txt             # Reviews with rating = 5
│   │
│   │── rating_1_counts.txt      # gmap_id counts for rating = 1 (Step 2 output)
│   │── rating_2_counts.txt      # gmap_id counts for rating = 2
│   │── rating_3_counts.txt      # gmap_id counts for rating = 3
│   │── rating_4_counts.txt      # gmap_id counts for rating = 4
│   │── rating_5_counts.txt      # gmap_id counts for rating = 5
│   │
│   │── final_gmap_ratings.csv   # Final processed data with total reviews & avg rating
│
└── logs/                    # Directory for SLURM logs
    │── first_1.out              # Log for First.py processing rating_1.txt
    │── first_2.out              # Log for First.py processing rating_2.txt
    │── first_3.out              # Log for First.py processing rating_3.txt
    │── first_4.out              # Log for First.py processing rating_4.txt
    │── first_5.out              # Log for First.py processing rating_5.txt
    │── second.out               # Log for Second.py processing all counts
