
INSERT INTO silver.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt)
SELECT
prd_id, 
REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, -- this is to match the table's id in erp_px_cat_g1v2
SUBSTRING(prd_key, 7,LEN(prd_key)) AS prd_key,
prd_nm, 
ISNULL(prd_cost,0) AS prd_cost, 
CASE UPPER(TRIM(prd_line)) 
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
	WHEN 'T' THEN 'Touring'
	WHEN 'S' THEN 'Other Sales'
	ELSE 'n/a' 
END AS prd_line,
CAST(prd_start_dt AS DATE) AS prd_start_dt,
CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info

-- DATA QUALITY CHECKS

-- WHERE SUBSTRING(prd_key, 7,LEN(prd_key)) NOT IN
-- (SELECT sls_prd_key FROM bronze.crm_sales_details) -- Check the product exists in the sales or not. If not it means that there is no purchase of that product in the erp sales.


-- WHERE REPLACE(SUBSTRING(prd_key,1,5),'-','_') NOT IN
-- (SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2) -- to check what category is not matching with the erp ones. found CO_PE not in the erp table.

-- Check for unwanted blank spaces
-- We Expect: No results
SELECT prd_line FROM bronze.crm_prd_info WHERE prd_line != TRIM(prd_line)

-- Check for nulls or negative numbers
-- We Expect: No results
SELECT prd_cost FROM bronze.crm_prd_info WHERE prd_cost < 0 or prd_cost IS NULL

-- Check for Invalid Date Orders. (Start date is larger then the end date which makes no sense)
-- Solution is we switch the end date with start date and end date = start date of the next record -1 day
SELECT *
FROM bronze.crm_prd_info WHERE  prd_end_dt < prd_start_dt

SELECT sls_prd_key FROM bronze.crm_sales_details
SELECT DISTINCT id FROM bronze.erp_px_cat_g1v2 -- the initial 5 letter of prd_key this is the same as cat id

-- Check for Nulls or Duplicates in Primary Key
SELECT prd_key, COUNT(*) FROM bronze.crm_prd_info GROUP BY prd_key HAVING COUNT(*) >1 OR prd_key IS NULL;

SELECT * FROM bronze.crm_prd_info WHERE prd_key = 'AC-HE-HL-U509';

-- Remove duplicates in the primary key by getting the latest updated date for customer info

SELECT * FROM
(
SELECT prd_key, ROW_NUMBER() OVER (PARTITION BY prd_key ORDER BY prd_start_dt DESC) AS flag_last 
FROM bronze.crm_prd_info
WHERE prd_key IS NOT NULL
) t 
WHERE flag_last = 1; -- select the most recent record per product.