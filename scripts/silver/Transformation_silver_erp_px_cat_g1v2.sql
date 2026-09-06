INSERT INTO silver.erp_px_cat_g1v2( id, cat, subcat, maintenance) 
SELECT id, cat, subcat, maintenance FROM bronze.erp_px_cat_g1v2


SELECT * FROM silver.crm_prd_info ORDER BY cat_id

-- Check for unwated spaces
SELECT * FROM bronze.erp_px_cat_g1v2 WHERE id != TRIM(id) OR cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Data Standardization and consistency
SELECT DISTINCT cat, subcat FROM bronze.erp_px_cat_g1v2

SELECT * FROM silver.erp_px_cat_g1v2