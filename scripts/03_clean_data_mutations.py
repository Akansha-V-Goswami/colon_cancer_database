
import pandas as pd

# =========================
# LOAD
# =========================
file = "C:\\Users\\goswa\\Downloads\\data_mutations.txt"

df = pd.read_csv(
    file,
    sep="\t",
    comment="#"
)


# =========================
# CORE IDS
# =========================
df["patient_id"] = df["Tumor_Sample_Barcode"].astype(str).str.split("_").str[0]
df["sample_id"] = df["Tumor_Sample_Barcode"].astype(str)

# =========================
# CLEAN NUMERIC FIELDS
# =========================
df["Start_Position"] = pd.to_numeric(df["Start_Position"], errors="coerce")
df["End_Position"] = pd.to_numeric(df["End_Position"], errors="coerce")

# =========================
# CREATE MUTATION ID
# =========================
df["mutation_id"] = (
    df["Hugo_Symbol"].astype(str) + "_" +
    df["Chromosome"].astype(str) + "_" +
    df["Start_Position"].astype(str) + "_" +
    df["Reference_Allele"].astype(str) + "_" +
    df["Tumor_Seq_Allele2"].astype(str)
)

# =========================
# SELECT CLEAN CORE COLUMNS ONLY
# =========================
clean_df = df[[
    # IDs
    "mutation_id",
    "sample_id",
    "patient_id",

    # Gene info
    "Hugo_Symbol",
    "Entrez_Gene_Id",
    "Chromosome",
    "Start_Position",
    "End_Position",
    "Strand",

    # Variant info
    "Consequence",
    "Variant_Classification",
    "Variant_Type",
    "Reference_Allele",
    "Tumor_Seq_Allele1",
    "Tumor_Seq_Allele2",

    # Clinical mutation annotation
    "HGVSc",
    "HGVSp",
    "Transcript_ID",

    # Validation / QC
    "Validation_Status",
    "Mutation_Status",
    "Sequencing_Phase",

    # Counts (important for downstream TMB / purity work)
    "t_ref_count",
    "t_alt_count",
    "n_ref_count",
    "n_alt_count"
]]

# =========================
# CLEAN UP TYPES
# =========================
for col in ["t_ref_count","t_alt_count","n_ref_count","n_alt_count"]:
    if col in clean_df.columns:
        clean_df[col] = pd.to_numeric(clean_df[col], errors="coerce")

# =========================
# DROP EXACT DUPLICATES
# =========================
clean_df = clean_df.drop_duplicates()

# =========================
# EXPORT SINGLE FILE
# =========================
clean_df.to_csv("clean_mutations_master.csv", index=False)

print("Done → clean_mutations_master.csv created")