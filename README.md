# Illinois Private Passenger Auto No-Fault (PIP) Market Analysis (2024)

## 👤 Author: Andy MINGA
**Role:** Data Engineer / Analytics Engineer  
**Tech Stack:** Snowflake, dbt, Power BI, SQL, Python (Tabula-py, Pandas)

---

## 📊 Executive Summary
This project is an end-to-end data engineering and business intelligence solution focusing on a specialized niche of the insurance industry: **Private Passenger Auto No-Fault (Personal Injury Protection)**. 

By automating the extraction of regulatory filings from the **Illinois Department of Insurance (IDOI)**, I built a structured data pipeline that moves from unstructured PDF tables to a high-performance executive dashboard. The project demonstrates the ability to isolate specific lines of business and provide accurate market-share insights for C-suite decision-making.

## 📂 Data Provenance & Source
* **Primary Source:** [IDOI 2024 P&C Market Share Report](https://idoi.illinois.gov/content/dam/soi/en/web/insurance/reports/reports/2024-pc-market-share-report.pdf)
* **Specific Line of Business:** "Private Passenger Auto No-Fault (Personal Injury Protection)"
* **Data Context:** The analysis targets consumer-grade No-Fault insurance, distinct from commercial or liability-only filings.

## 🏗️ Technical Architecture

### 1. Data Extraction (Python)
* **Tooling:** `tabula-py` and `pandas`.
* **Methodology:** Targeted pages **223–230** of the official report. 
* **Engineering:**
    * Used `multiple_tables=True` to handle data spanning across page breaks.
    * Implemented `df.dropna(subset=['Company Name'])` to programmatically remove PDF artifacts, headers, and footer noise.
    * Exported cleaned results to `il_auto_market_share_raw.csv` for cloud ingestion.

### 2. Data Transformation (dbt & Snowflake)
* **Warehouse:** Data was ingested into **Snowflake** (Bronze Layer).
* **Medallion Architecture:** Used **dbt** to clean, cast, and model the data into a Gold reporting layer.
* **Business Logic:** Implemented **SQL Window Functions** to calculate `MARKET_SHARE_PCT`. 
    * *Formula:* `PREMIUMS_WRITTEN / SUM(PREMIUMS_WRITTEN) OVER()`
    * This ensures percentages are calculated against the specific 2024 No-Fault market total.

### 3. Visualization (Power BI)
* **KPIs:** Real-time tracking of Total Premiums and Active Provider count.
* **Competitive Intelligence:** Utilized Treemaps and Donut charts to highlight market concentration among top national carriers.
* **DAX Optimization:** Built custom measures to maintain data integrity, preventing "Filter Distortion" when drilling down into specific company groups.

## 🧠 Key Challenges & Solutions

### 🛡️ Programmatic PDF Parsing
**Challenge:** Insurance reports often have irregular table structures that fail with standard copy-paste or simple OCR.
**Solution:** I used Python's `tabula` with a `stream` approach (lattice=False) to reliably capture tabular data from the PDF based on coordinate whitespace, ensuring 100% of rows were captured.

### 🧹 Entity Normalization
**Challenge:** Companies often file under different names or subsidiary codes.
**Solution:** I used dbt to create a mapping layer, ensuring that market share is attributed to the correct parent entity, providing a more accurate view of true market dominance.

## 🚀 How to Run
1.  **Extract:** Run `extract_market_share.ipynb` to process the IDOI PDF.
2.  **Load:** Ingest the resulting CSV into **Snowflake**.
3.  **Transform:** Execute `dbt run` to generate the market share models.
4.  **Analyze:** Open `IL_Insurance_Market_2024.pbix` to view the interactive findings.

---
*Disclaimer: This analysis is based on the 2024 Annual Statements filed with the Illinois Department of Insurance.*
