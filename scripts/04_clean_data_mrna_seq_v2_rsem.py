import pandas as pd

# -----------------------------
# 1. Load file
# -----------------------------
file_path = "C:\\Users\\goswa\\Downloads\\data_mrna_seq_v2_rsem.txt"

df = pd.read_csv(file_path, sep="\t")

# -----------------------------
# 2. Basic cleaning
# -----------------------------

# Standardize column names (optional but useful)
df.columns = df.columns.str.strip()

# Remove completely duplicated rows
df = df.drop_duplicates()

# Ensure gene identifiers are clean strings
df["Hugo_Symbol"] = df["Hugo_Symbol"].astype(str).str.strip()

# Ensure Entrez IDs are numeric where possible
df["Entrez_Gene_Id"] = pd.to_numeric(df["Entrez_Gene_Id"], errors="coerce")

# Drop rows without gene symbol (optional but common cleanup)
df = df.dropna(subset=["Hugo_Symbol"])

# -----------------------------
# 3. Convert expression columns to numeric
# -----------------------------
id_cols = ["Hugo_Symbol", "Entrez_Gene_Id"]
expr_cols = [c for c in df.columns if c not in id_cols]

df[expr_cols] = df[expr_cols].apply(pd.to_numeric, errors="coerce")

# Optional: fill missing values (choose one strategy)
# df = df.fillna(0)  # or keep NaNs depending on analysis

# -----------------------------
# 4. Save cleaned dataset
# -----------------------------
output_path = r"cleaned_mrna_seq_v2_rsem.csv"
df.to_csv(output_path, index=False)

print(f"Cleaned file saved to: {output_path}")