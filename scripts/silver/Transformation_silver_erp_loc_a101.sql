INSERT INTO silver.erp_loc_a101(
cid,cntry)
SELECT 
UPPER(TRIM(REGEXP_REPLACE(cid,'-',''))) AS cid, 
CASE WHEN cntry IN ('US','USA') THEN 'United States'
	WHEN cntry = 'DE' THEN 'Germany'
	WHEN cntry IS NULL OR cntry = '' THEN 'n/a'
	ELSE cntry
	END AS cntry
FROM bronze.erp_loc_a101


-- CHECKS
SELECT DISTINCT UPPER(TRIM(REGEXP_REPLACE(cid,'-',''))) AS cid FROM bronze.erp_loc_a101
SELECT DISTINCT CASE WHEN cntry IN ('US','USA') THEN 'United States'
	WHEN cntry = 'DE' THEN 'Germany'
	WHEN cntry IS NULL OR cntry = '' THEN 'n/a'
	ELSE cntry
	END AS cntry FROM bronze.erp_loc_a101

SELECT cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date, dwh_create_date FROM silver.crm_cust_info