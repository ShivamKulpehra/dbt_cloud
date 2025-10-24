{{ config(
    materialized='table',
    schema='bronze'
) }}

-- Step 1: Source data from silver layer
WITH base AS (
    SELECT 
        customer_id,
        customer_name,
        city,
        signup_date
    FROM dbt_cata.source.customers
),

-- Step 2: Transform / enhance data
enhanced AS (
    SELECT
        customer_id,
        customer_name,
        city,
        signup_date,
        -- Derived columns
        DATE_PART('year', signup_date) AS signup_year,
        CASE 
            WHEN city IN ('DELHI', 'MUMBAI', 'BANGALORE') THEN 'METRO'
            ELSE 'NON-METRO'
        END AS city_type
    FROM base
)

-- Step 3: Final output
SELECT * FROM enhanced
