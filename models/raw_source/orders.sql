{{ config(
    materialized='table',
    schema='bronze'
) }}

-- Step 1: Load data from the seed (bronze layer)
WITH base AS (
    SELECT 
        order_id,
        customer_id,
        order_date,
        status,
        total_amount,
        created_timestamp
    FROM dbt_cata.source.orders  -- seed ka reference
),

-- Step 2: Clean data
cleaned AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        UPPER(status) AS status,  -- standardize status text
        total_amount,
        created_timestamp
    FROM base
    WHERE total_amount > 0  -- ignore cancelled or invalid
)

SELECT * FROM cleaned
