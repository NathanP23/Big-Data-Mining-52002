import pandas as pd
import sys

def count_gmap_ids(input_file, output_file):
    try:
        # Load CSV file (ensuring proper column names)
        df = pd.read_csv(input_file)
        # Ensure 'gmap_id' column exists
        if "gmap_id" not in df.columns:
            print(f"❌ Error: 'gmap_id' column not found in {input_file}")
            return
        # Count occurrences of gmap_id
        gmap_counts = df["gmap_id"].value_counts().reset_index()
        gmap_counts.columns = ["gmap_id", "count"]
        # Save results to a CSV-formatted TXT file
        gmap_counts.to_csv(output_file, index=False)
        print(f"✅ Completed processing: {input_file} -> {output_file}")
    except Exception as e:
        print(f"❌ Error processing {input_file}: {e}")

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Usage: python3 count_gmap.py <input_file> <output_file>")
        sys.exit(1)
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    count_gmap_ids(input_file, output_file)
