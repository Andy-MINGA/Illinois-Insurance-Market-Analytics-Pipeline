-- ==========================================
-- STEP 3: ANALYTICAL INSIGHTS
-- Purpose: Extract business value for Power BI
-- ==========================================

USE DATABASE ILLINOIS_INSURANCE_DB;
USE SCHEMA STAGING;

-- QUERY 1: The Profitability Leaderboard
-- Business Question: Which companies are the most efficient at underwriting?
SELECT 
    COMPANY_NAME, 
    PREMIUMS_EARNED, 
    LOSSES_INCURRED,
    (PREMIUMS_EARNED - LOSSES_INCURRED) AS UNDERWRITING_PROFIT,
    LOSS_RATIO_PCT
FROM MARKET_SHARE_CLEANED
WHERE PREMIUMS_EARNED > 1000000 -- Focus on companies with > $1M in scale
ORDER BY UNDERWRITING_PROFIT DESC;


-- QUERY 2: Market Concentration Analysis (Pareto Principle)
-- Business Question: How much of the market do the top 5 players control?
SELECT 
    CASE 
        WHEN MARKET_SHARE_PCT > 0.05 THEN COMPANY_NAME 
        ELSE 'OTHER SMALLER CARRIERS' 
    END AS CARRIER_GROUP,
    SUM(MARKET_SHARE_PCT) * 100 AS TOTAL_MARKET_SHARE_PERCENT
FROM MARKET_SHARE_CLEANED
GROUP BY 1
ORDER BY TOTAL_MARKET_SHARE_PERCENT DESC;


-- QUERY 3: High-Risk Carriers (Loss Ratio Outliers)
-- Business Question: Which companies are paying out more than they receive?
-- (A loss ratio over 100% means the company is losing money on claims)
SELECT 
    COMPANY_NAME, 
    LOSS_RATIO_PCT,
    PREMIUMS_WRITTEN
FROM MARKET_SHARE_CLEANED
WHERE LOSS_RATIO_PCT > 1.0
ORDER BY LOSS_RATIO_PCT DESC;