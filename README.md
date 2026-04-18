# Illinois Property & Casualty Insurance Market Analysis (2024)

## 👤 Author: Andy MINGA
**Role:** Data Engineer / Analytics Engineer  
**Tech Stack:** Snowflake, dbt, Power BI, SQL, Python (Data Extraction)

---

## 📊 Executive Summary
This project represents an end-to-end data engineering and business intelligence solution. It transforms raw, unstructured regulatory filings from the **Illinois Department of Insurance (IDOI)** into a high-performance executive dashboard. The analysis covers over **$5.7 Billion** in premiums across **222 active insurance companies**, providing a definitive "Source of Truth" for market share and competitive positioning in the state of Illinois.

## 🏗️ Technical Architecture
I utilized a **Modern Data Stack (MDS)** approach to ensure scalability, reproducibility, and data integrity:

1.  **Data Extraction & Ingestion (Python & Snowflake):** * **Source:** Unstructured Annual Report PDFs from the Illinois Dept of Insurance.
    * **Process:** Extracted financial data and normalized it into a structured format.
    * **Warehouse:** Ingested raw data into **Snowflake** (Bronze Layer).

2.  **Data Transformation (dbt - Data Build Tool):**
    * Applied **Medallion Architecture** principles to clean and model the data.
    * **Staging:** Standardized inconsistent company names and handled numeric conversions for premiums.
    * **Gold Layer:** Developed final reporting views.
    * **Business Logic:** Implemented **SQL Window Functions** to calculate `MARKET_SHARE_PCT`. 
        * *Formula:* `SUM(Premiums) OVER() / SUM(Premiums) BY Company`
        * This ensures that the "Total Market" denominator ($5.7bn) remains fixed, preventing math errors during filtering.

3.  **Visualization (Power BI):**
    * Designed a high-fidelity dashboard for C-suite stakeholders.
    * **KPIs:** Real-time tracking of Total Premium Volume and Active Entity Count.
    * **Competitive Analysis:** Used Treemaps and Donut charts to visualize market concentration.
    * **Searchability:** Integrated a "Company Name" slicer for granular drill-downs.

## 🧠 Key Challenges & Solutions

### 🛡️ The "Filter Distortion" Problem
**Challenge:** Initially, applying a "Top 10" filter to the Donut Chart caused Power BI to recalculate percentages based only on those 10 companies. This incorrectly inflated the market leader's (State Farm) share from **~29%** to **44%**.
**Solution:** I bypassed standard visual-level filtering by creating a DAX measure that references the **All-Company Total**. This maintained data integrity, ensuring that State Farm’s share is always shown relative to the *entire* $5.7B market, not just a filtered subset.

### 🧹 Data Normalization
**Challenge:** Regulatory filings often contain duplicate or slightly varied names for the same parent company (e.g., "State Farm Mut" vs "State Farm Mutual Auto").
**Solution:** I used **dbt** to create a mapping layer that cleaned and consolidated these entities, ensuring the "Active Companies" count (222) was accurate and not artificially inflated.

## 📈 Business Insights (FY 2024)
* **Total Market Volume:** $5.68 Billion.
* **Market Concentration:** The top 5 companies control nearly 55% of the total premium volume.
* **Dominant Leader:** **State Farm** is the market leader with a **28.73%** share, significantly outperforming the second-largest player, Progressive (8.08%).
* **The Long Tail:** 212 of the 222 companies compete for the remaining ~45% of the market, indicating a highly competitive landscape outside the top tier.

## 🚀 How to Run
1.  **Snowflake:** Run the ingestion scripts located in `/snowflake_setup`.
2.  **dbt:** Execute `dbt run` to build the staging and gold models.
3.  **Power BI:** Open `IL_Insurance_Market_2024.pbix` to view the interactive dashboard.

---
*Disclaimer: This analysis is based on the 2024 Annual Statements filed with the Illinois Department of Insurance.*
