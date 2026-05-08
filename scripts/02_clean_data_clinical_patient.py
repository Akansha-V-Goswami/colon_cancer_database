import pandas as pd

# =========================
# LOAD DATA (YOUR FORMAT)
# =========================
file = "C:\\Users\\goswa\\Downloads\\data_clinical_patient.txt"

patient = pd.read_csv(
    file,
    sep="\t",
    comment="#"
)

# =========================
# STANDARDIZE COLUMN NAMES
# =========================
patient.columns = patient.columns.str.lower().str.strip()

# =========================
# CLEAN PATIENT ID
# =========================
patient['patient_id'] = patient['patient_id'].astype(str).str.strip().str.upper()

# =========================
# HANDLE MISSING VALUES
# =========================
patient = patient.replace({
    '[Not Available]': None,
    'NA': None,
    'nan': None
})

# =========================
# CLEAN TEXT FIELDS
# =========================
for col in patient.columns:
    if patient[col].dtype == 'object':
        patient[col] = patient[col].astype(str).str.strip()

# =========================
# STANDARDIZE COMMON FIELDS
# =========================

# Sex
if 'sex' in patient.columns:
    patient['sex'] = patient['sex'].str.upper()

# Survival status (Alive/Dead → standardized)
if 'os_status' in patient.columns:
    patient['os_status'] = patient['os_status'].str.upper()

# =========================
# CONVERT NUMERIC COLUMNS
# =========================
numeric_cols = [
    'age',
    'os_months',
    'dfs_months',
    'mutation_count'
]

for col in numeric_cols:
    if col in patient.columns:
        patient[col] = pd.to_numeric(patient[col], errors='coerce')

# =========================
# REMOVE DUPLICATES
# =========================
patient = patient.drop_duplicates(subset=['patient_id'])

# =========================
# OPTIONAL: SORT FOR CLEANNESS
# =========================
patient = patient.sort_values(by='patient_id')

# =========================
# SAVE CLEAN FILE (same folder)
# =========================
output_file = file.replace(".txt", "_cleaned.csv")
patient.to_csv(output_file, index=False)

print(f"✅ Cleaned patient file saved as: {output_file}")