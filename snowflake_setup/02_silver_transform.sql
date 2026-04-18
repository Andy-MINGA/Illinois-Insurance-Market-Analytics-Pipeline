-- ==========================================
-- STEP 2: SILVER TRANSFORMATION
-- Purpose: Clean currency/percent symbols and cast to numbers
-- ==========================================

USE ROLE ACCOUNTADMIN;

-- 1. Create a new Schema for our clean data
CREATE OR REPLACE SCHEMA ILLINOIS_INSURANCE_DB.STAGING;

-- 2. Create the View
CREATE OR REPLACE VIEW ILLINOIS_INSURANCE_DB.STAGING.MARKET_SHARE_CLEANED AS
SELECT 
    NAIC_CODE,
    COMPANY_NAME,
    DOMICILE,
    -- Clean Premiums Written
    CAST(REPLACE(REPLACE(PREMIUMS_WRITTEN, '$', ''), ',', '') AS NUMBER(38,2)) AS PREMIUMS_WRITTEN,
    -- Clean Market Share
    CAST(REPLACE(MARKET_SHARE, '%', '') AS FLOAT) / 100 AS MARKET_SHARE_PCT,
    -- Clean Premiums Earned
    CAST(REPLACE(REPLACE(PREMIUMS_EARNED, '$', ''), ',', '') AS NUMBER(38,2)) AS PREMIUMS_EARNED,
    -- Clean Losses Incurred
    CAST(REPLACE(REPLACE(REPLACE(LOSSES_INCURRED, '$', ''), ',', ''), '(', '-') AS NUMBER(38,2)) AS LOSSES_INCURRED,
    -- Clean Loss Ratio
    CAST(REPLACE(LOSS_RATIO, '%', '') AS FLOAT) / 100 AS LOSS_RATIO_PCT
FROM ILLINOIS_INSURANCE_DB.RAW.MARKET_SHARE_RAW;