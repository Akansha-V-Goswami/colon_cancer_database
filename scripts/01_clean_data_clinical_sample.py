import pandas as pd
#CLEANING CLINICAL SAMPLE DATA
# =========================
# LOAD DATA (skip metadata)
# =========================
file = "C:\\Users\\goswa\\Downloads\\data_clinical_sample.txt"
sample = pd.read_csv(
    file,
    sep="\t",
    comment="#"
)

# =========================
# STANDARDIZE COLUMN NAMES
# =========================
sample.columns = sample.columns.str.lower().str.strip()

# =========================
# CLEAN IDS
# =========================
sample['patient_id'] = sample['patient_id'].astype(str).str.strip().str.upper()
sample['sample_id'] = sample['sample_id'].astype(str).str.strip().str.upper()

# =========================
# HANDLE MISSING VALUES
# =========================
sample = sample.replace({
    '[Not Available]': None,
    'NA': None
})

# =========================
# CONVERT DATA TYPES
# =========================
numeric_cols = ['copy_number', 'tmb_nonsynonymous']
for col in numeric_cols:
    if col in sample.columns:
        sample[col] = pd.to_numeric(sample[col], errors='coerce')

bool_cols = [
    'sequenced', 'mrna_data', 'microrna_data',
    'methylation_status', 'protein', 'phosphoprotein'
]

for col in bool_cols:
    if col in sample.columns:
        sample[col] = pd.to_numeric(sample[col], errors='coerce')

# =========================
# CLEAN TEXT FIELDS
# =========================
text_cols = [
    'specimen_preservation', 'msi_status', 'pathology_status',
    'primary_site', 'oncotree_code', 'cancer_type',
    'cancer_type_detailed'
]

for col in text_cols:
    if col in sample.columns:
        sample[col] = sample[col].astype(str).str.strip()

# =========================
# REMOVE DUPLICATES
# =========================
sample = sample.drop_duplicates(subset=['sample_id'])

# =========================
# SAVE ONE CLEAN CSV
# =========================
sample.to_csv("clean_sample_flat.csv", index=False)

print("✅ One clean CSV created: clean_sample_flat.csv")