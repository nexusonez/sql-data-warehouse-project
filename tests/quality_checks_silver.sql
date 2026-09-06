/*
-- =======================================================================================
-- Quality Checks
-- =======================================================================================
Script Purpose:
	This script performs various quality checks for data consistency, accuracy,
	and standardization across the 'silver' schemas. It includes checks for:
	- Null or duplicate primary keys.
	- Unwanted spaces in string field.
	- Data standardization and consistency.
	- Invalid date ranges and orders.
	- Data consistency between related fields.

Usage Notes:
	- Run these checks after data loading Silver Layer.
	- Investigate and resolve any discrepencies found during the checks.
-- =======================================================================================
*/
-- =======================================================================================
-- Checking 'silver.crm_cust_info'
-- =======================================================================================
-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info;


-- DATA QUALITY CHECK FOR Silver layer
-- Check for Nulls or Duplicates in Primary Key
SELECT cst_id, count(*) FROM silver.crm_cust_info GROUP BY cst_id HAVING COUNT(*) > 1 OR cst_id IS NULL


-- Remove duplicates in the primary key by getting the latest updated date for customer info
SELECT * FROM(
SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last FROM silver.crm_cust_info
) t WHERE flag_last = 1;

-- =======================================================================================
-- Checking 'silver.crm_prd_info'
-- =======================================================================================
-- Check for unwanted blank spaces
-- We Expect: No results
SELECT prd_line FROM silver.crm_prd_info WHERE prd_line != TRIM(prd_line)

-- Check for nulls or negative numbers
-- We Expect: No results
SELECT prd_cost FROM silver.crm_prd_info WHERE prd_cost < 0 or prd_cost IS NULL

-- Check for Invalid Date Orders. (Start date is larger then the end date which makes no sense)
-- Solution is we switch the end date with start date and end date = start date of the next record -1 day
SELECT *
FROM silver.crm_prd_info WHERE  prd_end_dt < prd_start_dt

SELECT sls_prd_key FROM silver.crm_sales_details
SELECT DISTINCT id FROM silver.erp_px_cat_g1v2 -- the initial 5 letter of prd_key this is the same as cat id

-- Check for Nulls or Duplicates in Primary Key
SELECT prd_key, COUNT(*) FROM silver.crm_prd_info GROUP BY prd_key HAVING COUNT(*) >1 OR prd_key IS NULL;


-- Remove duplicates in the primary key by getting the latest updated date for customer info

SELECT * FROM
(
SELECT prd_key, ROW_NUMBER() OVER (PARTITION BY prd_key ORDER BY prd_start_dt DESC) AS flag_last 
FROM silver.crm_prd_info
WHERE prd_key IS NOT NULL
) t 
WHERE flag_last = 1; -- select the most recent record per product.
-- =======================================================================================
-- Checking 'silver.crm_sales_details'
-- =======================================================================================
-- Check for invalid dates
SELECT NULLIF(sls_order_dt,0) sls_order_dt 
FROM bronze.crm_sales_details 
WHERE sls_order_dt <= 0 
OR LEN(sls_order_dt) != 8 
OR sls_order_dt > 20500101 
OR sls_order_dt < 19000101

-- Check for invalid dates
SELECT NULLIF(sls_ship_dt,0) sls_ship_dt 
FROM bronze.crm_sales_details 
WHERE sls_ship_dt <= 0 
OR LEN(sls_ship_dt) != 8 
OR sls_ship_dt > 20500101 
OR sls_ship_dt < 19000101

-- Check for invalid dates
SELECT NULLIF(sls_due_dt,0) sls_due_dt 
FROM bronze.crm_sales_details 
WHERE sls_due_dt <= 0 
OR LEN(sls_due_dt) != 8 
OR sls_due_dt > 20500101 
OR sls_due_dt < 19000101

--Check for Invalid Dates Order (Order date should always be earlier than shipping date or due date)
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt


--Check business rule
--> Sales = Quatity * Price
--> Values must not be NULL, zero, or negative

SELECT
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

--SOLUTIONS
--If sales is wrong (zero, null, or negative) calculate it using quantity and price
--IF price is zero or null, calculate using sales and quantity
-- if price is negative convert it to positive
SELECT
sls_sales as old_sls_sales,
sls_quantity,
sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price iS NULL OR sls_price <= 0  
	THEN sls_sales / NULLIF(sls_quantity,0)
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-- =======================================================================================
-- Checking 'silver.erp_cust_az12'
-- =======================================================================================
--Identify out of range dates
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE() -- checking birthdates that are more than 100 y/o and future birthdays

-- Check gender
SELECT DISTINCT gen, CASE WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female' 
	WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
	ELSE 'n/a'
	END AS gen FROM silver.erp_cust_az12
-- =======================================================================================
-- Checking 'silver.erp_loc_a101'
-- =======================================================================================
-- CHECKS for unwanted spaces and normalize data types
SELECT DISTINCT UPPER(TRIM(REGEXP_REPLACE(cid,'-',''))) AS cid FROM silver.erp_loc_a101
SELECT DISTINCT CASE WHEN cntry IN ('US','USA') THEN 'United States'
	WHEN cntry = 'DE' THEN 'Germany'
	WHEN cntry IS NULL OR cntry = '' THEN 'n/a'
	ELSE cntry
	END AS cntry FROM silver.erp_loc_a101

-- =======================================================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- =======================================================================================
-- Check for unwanted spaces
SELECT * FROM silver.erp_px_cat_g1v2 WHERE id != TRIM(id) OR cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Data Standardization and consistency
SELECT DISTINCT cat, subcat FROM silver.erp_px_cat_g1v2
