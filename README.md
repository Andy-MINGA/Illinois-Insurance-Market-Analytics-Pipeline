# Illinois Other Private Passenger Auto Liability Market Analysis (2024)

## 👤 Author: Andy MINGA
**Role:** Data Engineer / Analytics Engineer  
**Tech Stack:** Snowflake, dbt, Power BI, SQL, Python (Tabula-py, Pandas)

---

## 📊 Executive Summary
This project delivers an end-to-end data engineering pipeline and competitive intelligence dashboard focusing on **Other Private Passenger Auto Liability** within the state of Illinois. 

By programmatically extracting data from the **Illinois Department of Insurance (IDOI)** annual filings, I transformed unstructured financial tables into a structured "Source of Truth." This analysis provides critical insights into market concentration, helping stakeholders identify dominant carriers and competitive shifts in the automotive liability sector for the 2024 fiscal year.

## Data Provenance & Source
* **Primary Source:** [IDOI 2024 P&C Market Share Report](https://idoi.illinois.gov/content/dam/soi/en/web/insurance/reports/reports/2024-pc-market-share-report.pdf)
* **Specific Focus:** "Other Private Passenger Auto Liability"
* **Data Context:** This specific line represents a significant portion of the Illinois P&C market, covering third-party liability claims for private vehicle owners.

## Technical Architecture

### 1. Automated Extraction (Python)
* **Tooling:** `tabula-py` and `pandas`.
* **Methodology:** Targeted pages **223–230** of the official report, which contain the comprehensive list of providers for this specific line.
* **Engineering:** * Set `multiple_tables=True` to accurately capture data across the 8-page span.
    * Implemented `df.dropna(subset=['Company Name'])` to programmatically purge non-data rows (headers/footers/artifacts) during the extraction phase.
    * Resulted in a clean `il_auto_market_share_raw.csv` ready for cloud ingestion.

### 2. Cloud Data Warehousing (Snowflake & dbt)
* **Infrastructure:** Ingested raw CSV data into a **Snowflake** landing zone.
* **Medallion Architecture:** Utilized **dbt** to clean data types and normalize company names.
* **Analytical Modeling:** Developed SQL models using **Window Functions** to calculate market share percentages.
    * *Logic:* `PREMIUMS_WRITTEN / SUM(PREMIUMS_WRITTEN) OVER()`
    * This ensures calculations remain anchored to the total premium volume for this specific liability line.

### 3. Business Intelligence (Power BI)
* **Executive View:** High-level KPIs showing Total Direct Premiums Written and Total Active Companies.
* **Market Distribution:** Used Treemaps and Donut charts to visualize the massive footprint of top-tier carriers vs. the "Long Tail" of smaller providers.
* **DAX Precision:** Built measures to ensure market share remains accurate even when users filter for specific carriers or groups, preventing "Filter Distortion" in the percentages.

## Key Challenges & Solutions

### Programmatic PDF Parsing
**Challenge:** Extracting data from 8 pages of a regulatory PDF often results in misaligned columns or missing rows due to page breaks and complex headers.
**Solution:** I used Python to automate the extraction, specifying the exact page range (223–230) and using a stream-based parsing method (`lattice=False`) to capture data accurately based on the document's whitespace structure.

### Entity Normalization
**Challenge:** Identifying true market dominance is difficult when companies file under multiple subsidiary names (e.g., "State Farm Fire" vs "State Farm Mutual").
**Solution:** I built a dbt transformation layer to aggregate these entities, allowing for a parent-company level view of market share and ranking.

## How to Run
1.  **Extract:** Run the Python script to process the IDOI PDF and generate the raw dataset.
2.  **Load:** Upload the CSV to the Snowflake stage.
3.  **Transform:** Execute `dbt run` to generate the final analytical models.
4.  **Visualize:** Connect Power BI to the Snowflake Gold layer to view the dashboard.

---
*Disclaimer: This analysis is based on the 2024 Annual Statements filed with the Illinois Department of Insurance.*
