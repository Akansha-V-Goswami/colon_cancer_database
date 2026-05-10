# colon_cancer_database
Script, data, and instructions to generate a database from The Cancer Genome Atlas data.

## Summary
The information in this database is both molecular and clinical, sourced from the Cancer Genome Atlas (TCGA), where large amounts of data from cancer patients and samples are available as downloadable TXTs. This database stores data into a single schema so that it can be easily found, interpreted, and compiled. Plus, the database can be more easily queried than multiple different files. This database is for researchers and students who are working with cancer data from TCGA that want to investigate, store, and understand the available information. And, the database can also handle different cancer types due to its schema. I populated this database with colorectal adenocarcinoma data, but that is not hardcoded into the setup. The final database contains 1.6 million+ rows of patient information, tumor samples, unique mutations, gene information, and mRNA expression from 106 samples. Using this database, helpful queries such as most differentially expressed genes by survival outcome, most mutated genes across all samples, sorting samples by cancer stage, and more can be performed. 

## Tools and Technologies
- DBMS: MySQL 
- Programming language(s): Python 3.12, SQL 
- Key packages or libraries: Pandas

## Repository Structure
sql: SQL scripts to create database schema. And, the database dump that will create and populate the database completely.  

scripts: Python scripts to clean the raw data and generate the insert sql statements from cleaned files. 

data: the raw data from TCGA and the cleaned data files from which the insert sql statements are created. 

docs: full project documentation with project overview, structure and cleaning logic, database design, dictionary, reproduction instructions, etc.. 

diagrams: normalized database diagrams from MySQL and database diagram with directionality. 

## Data Sources
This data was downloaded from TCGA under the NIH Genomic Data Sharing Policy. 

## How to Recreate the Database
1. Install required software.
2. Download the raw data.
3. Run the cleaning scripts in order.
4. Run the SQL schema file.
5. Populate the database using insert_data.sql. 
6. Load the cleaned data.
7. Compare with documentation to make sure database was properly created. 

## Documentation and Diagrams
Documentation and data dictionary are in docs/colon_cancer_database_documentation and model diagrams are located in diagrams.

