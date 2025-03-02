import pandas as pd
import json
import sys
import os

def aggregate_reviews(data_dir, meta_file, output_file):
    try:
        # Load metadata to map gmap_id -> business name
        gmap_to_name = {}
        with open(meta_file, 'r', encoding='utf-8') as f:
            for line in f:
                try:
                    item = json.loads(line.strip())  # Read each line as a JSON object
                    gmap_to_name[item["gmap_id"]] = item["name"]
                except json.JSONDecodeError:
                    print(f"⚠️ Skipping malformed JSON line: {line.strip()}")

        # Initialize dataframe
        all_data = pd.DataFrame(columns=["gmap_id", "count", "rating"])

        # Process each rating_i_counts.txt file
        for i in range(1, 6):
            rating_file = os.path.join(data_dir, f"rating_{i}_counts.txt")
            if os.path.exists(rating_file) and os.path.getsize(rating_file) > 0:
                df = pd.read_csv(rating_file)
                df["rating"] = i  # Assign the rating value to each row
                all_data = pd.concat([all_data, df], ignore_index=True)

        # Aggregate: Calculate total reviews & average rating per gmap_id
        grouped = all_data.groupby("gmap_id").agg(
            total_reviews=pd.NamedAgg(column="count", aggfunc="sum"),
            avg_rating=pd.NamedAgg(column="rating", aggfunc="mean")
        ).reset_index()

        # Map business names
        grouped["name"] = grouped["gmap_id"].map(gmap_to_name)

        # Sort: First by avg_rating (desc), then by total_reviews (desc)
        grouped = grouped.sort_values(by=["avg_rating", "total_reviews"], ascending=[False, False])

        # Save results
        grouped.to_csv(output_file, index=False)
        print(f"✅ Final results saved to: {output_file}")

        # Print top 3 businesses
        print("\n🏆 Top 3 Businesses:")
        print(grouped.head(3).to_string(index=False))

    except Exception as e:
        print(f"❌ Error in aggregation: {e}")

if __name__ == '__main__':
    if len(sys.argv) < 4:
        print("Usage: python3 Second.py <data_directory> <meta_file> <output_file>")
        sys.exit(1)

    data_dir = sys.argv[1]
    meta_file = sys.argv[2]
    output_file = sys.argv[3]

    aggregate_reviews(data_dir, meta_file, output_file)
