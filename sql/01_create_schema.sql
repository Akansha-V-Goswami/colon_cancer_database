-- =============================================================
-- DATABASE SCHEMA
-- Colorectal Cancer Genomics Dataset
-- =============================================================


-- =============================================================
-- CORE TABLES
-- =============================================================

CREATE TABLE PATIENT (
    patient_id   INT          PRIMARY KEY,
    sex          VARCHAR(6)               -- 'MALE' | 'FEMALE'
);

CREATE TABLE INTEGRATED_PHENOTYPE (
    integrated_phenotype_id  INT          PRIMARY KEY,
    phenotype                VARCHAR(12)  -- 'Epithelial' | 'EMT' | 'Hypermutated'
);

CREATE TABLE ENCOUNTER (
    encounter_id             INT          PRIMARY KEY,
    patient_id               INT          NOT NULL,
    integrated_phenotype_id  INT,
    age                      INT,
    os_status                VARCHAR(10),  -- '0:LIVING' | '1:DECEASED' | 'NONE'
    os_months                FLOAT,
    dfs_status               VARCHAR(21),  -- '0:DiseaseFree' | '1:Recurred/Progressed'
    dfs_months               FLOAT,
    cancer_stage             VARCHAR(9),   -- 'Stage I' through 'Stage IV'
    pathology_t_stage        VARCHAR(3),   -- 'T2' | 'T3' | 'T4a' | 'T4b'
    pathology_n_stage        VARCHAR(3),   -- 'N0' | 'N1' | 'N1a' | 'N1b' | 'N2a' | 'N2b'
    polyps_history           BOOLEAN,
    polyps_present           BOOLEAN,
    mutation_rate            FLOAT,
    mutation_phenotype       VARCHAR(5),   -- 'MSS' | 'MSI-H'
    histology                VARCHAR(12),  -- 'Mucinous' | 'Not Mucinous'

    FOREIGN KEY (patient_id)              REFERENCES PATIENT(patient_id),
    FOREIGN KEY (integrated_phenotype_id) REFERENCES INTEGRATED_PHENOTYPE(integrated_phenotype_id)
);


-- =============================================================
-- SAMPLE LOOKUP TABLES
-- =============================================================

CREATE TABLE PRESERVATION (
    preservation_id     INT          PRIMARY KEY,
    preservation_method VARCHAR(13)  -- 'Frozen Tissue'
);

CREATE TABLE MSI (
    msi_id      INT         PRIMARY KEY,
    msi_status  VARCHAR(5)  -- 'MSS' | 'MSI-H'
);

CREATE TABLE PATHOLOGY (
    pathology_id      INT         PRIMARY KEY,
    pathology_status  VARCHAR(9)  -- 'Malignant'
);

CREATE TABLE TUMOR_SITE (
    tumor_site_id  INT          PRIMARY KEY,
    tumor_site     VARCHAR(16)  -- 'Sigmoid Colon' | 'Ascending Colon' | etc.
);

CREATE TABLE ONCOTREE (
    oncotree_id    INT         PRIMARY KEY,
    oncotree_code  VARCHAR(4)  -- 'COAD'
);

CREATE TABLE CANCER (
    cancer_id    INT          PRIMARY KEY,
    cancer_type  VARCHAR(17)  -- 'Colorectal Cancer'
);

CREATE TABLE DETAILED_CANCER (
    detailed_cancer_id    INT          PRIMARY KEY,
    detailed_cancer_type  VARCHAR(20)  -- 'Colon Adenocarcinoma'
);


-- =============================================================
-- SAMPLE
-- =============================================================

CREATE TABLE SAMPLE (
    sample_id           INT      PRIMARY KEY,
    encounter_id        INT      NOT NULL,
    preservation_id     INT,
    msi_id              INT,
    pathology_id        INT,
    tumor_site_id       INT,
    oncotree_id         INT,
    cancer_id           INT,
    detailed_cancer_id  INT,
    sequenced           BOOLEAN,
    copy_number         BOOLEAN,
    mrna_data           BOOLEAN,
    microrna_data       BOOLEAN,
    methylation_status  BOOLEAN,
    protein_data        BOOLEAN,
    phosphoprotein_data BOOLEAN,
    tmb_nonsynonymous   FLOAT,

    FOREIGN KEY (encounter_id)       REFERENCES ENCOUNTER(encounter_id),
    FOREIGN KEY (preservation_id)    REFERENCES PRESERVATION(preservation_id),
    FOREIGN KEY (msi_id)             REFERENCES MSI(msi_id),
    FOREIGN KEY (pathology_id)       REFERENCES PATHOLOGY(pathology_id),
    FOREIGN KEY (tumor_site_id)      REFERENCES TUMOR_SITE(tumor_site_id),
    FOREIGN KEY (oncotree_id)        REFERENCES ONCOTREE(oncotree_id),
    FOREIGN KEY (cancer_id)          REFERENCES CANCER(cancer_id),
    FOREIGN KEY (detailed_cancer_id) REFERENCES DETAILED_CANCER(detailed_cancer_id)
);


-- =============================================================
-- GENOMIC TABLES
-- =============================================================

CREATE TABLE CHROMOSOME (
    chromosome_id    INT         PRIMARY KEY,
    chromosome_name  VARCHAR(2)  -- '1'-'22', 'X', 'Y'
);

CREATE TABLE GENE (
    gene_id         INT          PRIMARY KEY,
    hugo_symbol     VARCHAR(25)  UNIQUE NOT NULL,
    entrez_gene_id  INT,
    strand          CHAR(1),     -- '+' | '-'
    gene_type       VARCHAR(50),
    annotation      TEXT
);

CREATE TABLE MUTATION (
    mutation_id             INT           PRIMARY KEY,
    chromosome_id           INT,
    start_position          INT,
    end_position            INT,
    consequence             VARCHAR(66),  -- e.g. 'missense_variant&splice_region_variant'
    variant_classification  VARCHAR(22),  -- 'Missense_Mutation' | 'Silent' | 'Nonsense_Mutation' | etc.
    variant_type            VARCHAR(3),   -- 'SNP' | 'DEL' | 'INS'
    reference_allele        VARCHAR(261),
    tumor_seq_allele1       VARCHAR(261),
    tumor_seq_allele2       VARCHAR(156),
    hgvsc                   VARCHAR(190),
    hgvsp                   VARCHAR(176),
    transcript_id           VARCHAR(15),
    validation_status       VARCHAR(50),
    sequencing_phase        VARCHAR(50),

    FOREIGN KEY (chromosome_id) REFERENCES CHROMOSOME(chromosome_id)
);

-- Bridge: one mutation can be annotated against multiple genes
CREATE TABLE MUTATION_GENE (
    mutation_id  INT  NOT NULL,
    gene_id      INT  NOT NULL,

    PRIMARY KEY (mutation_id, gene_id),
    FOREIGN KEY (mutation_id) REFERENCES MUTATION(mutation_id),
    FOREIGN KEY (gene_id)     REFERENCES GENE(gene_id)
);

-- Bridge: links a mutation observation to a specific sample,
-- with per-sample sequencing read counts
CREATE TABLE SAMPLE_MUTATION (
    sample_id    INT  NOT NULL,
    mutation_id  INT  NOT NULL,
    t_ref_count  INT,           -- tumor reference allele read count
    t_alt_count  INT,           -- tumor alternate allele read count
    n_ref_count  INT,           -- normal reference allele read count
    n_alt_count  INT,           -- normal alternate allele read count
    mutation_status  VARCHAR(50),

    PRIMARY KEY (sample_id, mutation_id),
    FOREIGN KEY (sample_id)   REFERENCES SAMPLE(sample_id),
    FOREIGN KEY (mutation_id) REFERENCES MUTATION(mutation_id)
);


-- =============================================================
-- EXPRESSION
-- =============================================================

-- mRNA expression values (RSEM) from cleaned_mrna_seq_v2_rsem.csv
-- Wide-format source is normalised here to one row per sample/gene pair
CREATE TABLE RNA_EXPRESSION (
    expression_id   INT    PRIMARY KEY,
    sample_id       INT    NOT NULL,
    gene_id         INT    NOT NULL,
    expression_value FLOAT,

    FOREIGN KEY (sample_id) REFERENCES SAMPLE(sample_id),
    FOREIGN KEY (gene_id)   REFERENCES GENE(gene_id)
);

-- Protein / phosphoprotein expression
-- (add when quantitative proteomics data becomes available;
--  current dataset only has boolean presence flags on SAMPLE)
-- CREATE TABLE PROTEIN_EXPRESSION (
--     expression_id    INT    PRIMARY KEY,
--     sample_id        INT    NOT NULL,
--     gene_id          INT    NOT NULL,
--     expression_value FLOAT,
--     is_phospho       BOOLEAN,
--
--     FOREIGN KEY (sample_id) REFERENCES SAMPLE(sample_id),
--     FOREIGN KEY (gene_id)   REFERENCES GENE(gene_id)
-- );
