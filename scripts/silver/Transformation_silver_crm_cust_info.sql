-- Check for unwanted blank spaces
-- We Expect: No results
SELECT cst_firstname FROM bronze.crm_cust_info WHERE cst_firstname != TRIM(cst_firstname)

INSERT INTO silver.crm_cust_info (
cst_id, 
cst_key, 
cst_firstname, 
cst_lastname, 
cst_marital_status, 
cst_gndr, 
cst_create_date)


SELECT 
cst_id, 
cst_key, 
-- TRIM the white spacing in firstname and last name
TRIM(cst_firstname) AS cst_firstname, 
TRIM(cst_lastname) AS cst_lastname,
-- Standarize the full term for marital status and gender (Data Normalization/ Data standardization)
CASE WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	ELSE 'n/a' -- Handling missing data, cannot have NULL values
END AS cst_marital_status,
CASE WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	ELSE 'n/a'
END AS cst_gndr,
cst_create_date 
FROM (
-- Remove duplicates in the primary key by getting the latest updated date for customer info
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last 
FROM bronze.crm_cust_info
WHERE cst_id IS NOT NULL
) t WHERE flag_last = 1; -- Selects the most recent record per customer


-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info;


-- DATA QUALITY CHECK FOR Silver layer
-- Check for Nulls or Duplicates in Primary Key
SELECT cst_id, count(*) FROM silver.crm_cust_info GROUP BY cst_id HAVING COUNT(*) > 1 OR cst_id IS NULL


-- Check for Nulls or Duplicates in Primary Key

SELECT cst_id, count(*) FROM bronze.crm_cust_info GROUP BY cst_id HAVING COUNT(*) > 1 OR cst_id IS NULL

SELECT cst_id FROM bronze.crm_cust_info WHERE cst_id = 29466;
-- Remove duplicates in the primary key by getting the latest updated date for customer info
SELECT * FROM(
SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last FROM bronze.crm_cust_info
) t WHERE flag_last = 1;

SELECT * FROM silver.crm_cust_info;
