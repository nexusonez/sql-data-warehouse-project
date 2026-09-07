-- Check for any duplicates after joining table
SELECT cst_id, COUNT(*) FROM 
(SELECT 
ci.cst_id, 
ci.cst_key , 
ci.cst_firstname, 
ci.cst_lastname , 
ci.cst_marital_status , 
ci.cst_gndr,
ci.cst_create_date ,
ca.gen,
ca.bdate,
la.cntry
FROM silver.crm_cust_info ci 
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid)t GROUP BY cst_id HAVING COUNT(*) > 1

-- THERE is no duplicates so dont have to worry about it

--Checked on an error where gender is all n/a
SELECT * FROM silver.erp_cust_az12 WHERE cid = 'AW00011000'
SELECT * FROM bronze.erp_cust_az12 WHERE cid = 'NASAW00011000'

SELECT DISTINCT
	ci.cst_gndr, 
	ca.gen,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender info
		ELSE COALESCE(ca.gen, 'n/a')
	END AS new_gen
FROM silver.crm_cust_info ci 
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
ORDER BY 1,2


SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key, -- Surrogate Key is a system generated unique identifier assigned to each record in a table.
	ci.cst_id AS cutomer_id, 
	ci.cst_key AS customer_number, 
	ci.cst_firstname AS first_name, 
	ci.cst_lastname AS last_name, 
	la.cntry AS country,
	ci.cst_marital_status AS marital_status, 
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender info
		ELSE COALESCE(ca.gen, 'n/a')
	END AS gender,
	ca.bdate AS birth_date,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci 
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid

-- This is a dimension table