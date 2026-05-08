# colon_cancer_database
Script, data, and instructions to generate a database for The Cancer Genome Atlas data

## Summary
I designed and populated a colorectal cancer database. The information in this database is both molecular and clinical, sourced from the Cancer Genome Atlas (TCGA), where large amounts of data from cancer patients and samples are available as downloadable TXTs. This kind of data, spread across multiple files with the possibility of multiple redundancies, can be difficult to work with and combine with other information. This database solves this problem by cleaning and storing all the data into a single schema so that the data can be easily found, interpreted, and compiled. Plus, the database can be more easily queried than multiple different files. This database is for researchers and students who are working with colorectal cancer data from TCGA that want to investigate, store, and understand the available information. The final database contains 1.6 million+ rows of patient information, tumor samples, unique mutations, gene information, and mRNA expression from 106 samples. 

## Tools and Technologies
- DBMS: MySQL 
- Programming language(s): Python 3.12, SQL 
- Key packages or libraries: Pandas

## Repository Structure
sql: SQL scripts to create database schema. NOTE: the database dump with INSERT statements is not included here as the file is too large to upload to GitHub. Generate the INSERT statement using the generate_inserts.py file. 
scripts: Python scripts to clean the raw data and generate the insert sql statements from cleaned files. 
data: the raw data from TCGA and the cleaned data files from which the insert sql statements are created. 
docs: full project documentation with project overview, structure and cleaning logic, database design, dictionary, reproduction instructions, etc.. 
diagrams: Normalized database diagrams from MySQL and database diagram with directionality. 

## Data Sources
This data was downloaded from TCGA under the NIH Genomic Data Sharing Policy 

## How to Recreate the Database
1. Install required software.
2. Download the raw data from TCGA.
3. Run the cleaning scripts in order.
4. Run the SQL schema file.
5. Use generate_inserts.py to create insert_data.sql. 
6. Load the cleaned data.
7. Compare with documentation to make sure database was properly created. 

## Documentation and Diagrams
Documentation and data dictionary are in docs/coloncancer_database_documentation and model diagrams are located in diagrams.

## Important Note
Again, raw mutation data and SQL dump is not in this repository as they are too large to upload; make sure to download that file and create insert_data.sql in addition to using the data here. 
