-- This is a DIMENSION table as they are describing 1 objects
CREATE OR ALTER VIEW gold.dim_products AS
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