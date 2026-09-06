INSERT INTO silver.crm_sales_details(
	sls_ord_num, 
	sls_prd_key, 
	sls_cust_id, 
	sls_order_dt, 
	sls_ship_dt, 
	sls_due_dt, 
	sls_sales, 
	sls_quantity, 
	sls_price
)
SELECT
sls_ord_num, 
sls_prd_key, 
sls_cust_id, 
CASE WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) 
END AS sls_order_dt, 
CASE WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE) 
END AS sls_ship_dt,
CASE WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
	ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE) 
END AS sls_due_dt,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
	THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales, -- Recalculate sales if original value is missing or incorrect
sls_quantity, 
CASE WHEN sls_price iS NULL OR sls_price <= 0  
	THEN sls_sales / NULLIF(sls_quantity,0)
	ELSE sls_price
END AS sls_price -- Derive price if original value is invalid
FROM [bronze].[crm_sales_details]

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

SELECT * FROM silver.crm_sales_details