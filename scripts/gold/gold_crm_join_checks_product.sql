-- This is a DIMENSION table as they are describing 1 objects
SELECT 
	ROW_NUMBER() OVER( ORDER BY prd_start_dt, prd_key) AS product_key,
	pn.prd_id AS product_id, 
	pn.prd_key AS product_number, 
	pn.prd_nm AS product_name, 
	pn.cat_id AS category_id, 
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS product_cost,  
	pn.prd_line AS product_line, 
	pn.prd_start_dt AS start_date
	-- pn.prd_end_dt -- if end date is null then it is current latest product data
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL -- Filter out all historical data

-- Check for duplicates
SELECT prd_key, COUNT(*) FROM(
SELECT 
pn.prd_id, 
pn.cat_id, 
pn.prd_key, 
pn.prd_nm, 
pn.prd_cost, 
pn.prd_line, 
pn.prd_start_dt,
pc.cat,
pc.subcat,
pc.maintenance
-- pn.prd_end_dt -- if end date is null then it is current latest product data
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL -- Filter out all historical data
)t GROUP BY prd_key
HAVING COUNT(*) > 1
SELECT * FROM silver.erp_px_cat_g1v2


/*
TO CHECK FOR DUPLICATES
SELECT primary_key, COUNT(*) FROM(
)t GROUP BY primary_key
HAVING COUNT(*) > 1
*/