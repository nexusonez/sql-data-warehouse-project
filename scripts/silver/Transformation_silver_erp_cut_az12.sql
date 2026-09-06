INSERT INTO silver.erp_cust_az12(
cid,
bdate,
gen)
-- We are connecting the customer information table with customer key
SELECT
CASE WHEN cid LIKE 'NAS%'							-- removed NAS prefix if present
	THEN SUBSTRING(cid,4 ,LEN(cid))
	ELSE cid
END AS cid,
CASE WHEN bdate > GETDATE() THEN NULL				-- set future birthdays to null
	ELSE bdate
END AS bdate,
CASE WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female'		-- normalized gender values and handle unknown cases
	WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
	ELSE 'n/a'
	END AS gen
FROM bronze.erp_cust_az12



--Identify out of range dates
SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE() -- checking birthdates that are more than 100 y/o and future birthdays

-- Check gender
SELECT DISTINCT gen, CASE WHEN UPPER(TRIM(gen)) = 'F' THEN 'Female' 
	WHEN UPPER(TRIM(gen)) = 'M' THEN 'Male'
	ELSE 'n/a'
	END AS gen FROM bronze.erp_cust_az12

SELECT * FROM silver.crm_cust_info