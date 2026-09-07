/*
-- =======================================================================================
-- Quality Checks
-- =======================================================================================
Script Purpose:
	This script performs various quality checks for data consistency, accuracy,
	and standardization across the 'gold' schemas. It includes checks for:
	- Null or duplicate primary keys.
	- Unwanted spaces in string field.
	- Data standardization and consistency.
	- Invalid date ranges and orders.
	- Data consistency between related fields.

Usage Notes:
	- Run these checks after data loading Gold Layer.
	- Investigate and resolve any discrepencies found during the checks.
-- =======================================================================================
*/
-- =======================================================================================
-- Checking 'gold.dim_customers'
-- =======================================================================================
-- Check for uniqueness of customer key in gold.dim_customers
-- Expectation: No results
SELECT 
customer_key, 
COUNT(*) AS duplicate_count
FROM gold.dim_customers 
GROUP BY customer_key 
HAVING COUNT(*) >1;

-- =======================================================================================
-- Checking 'gold.product_key'
-- =======================================================================================
-- Check for uniqueness of product key in gold.dim_customers
-- Expectation: No results
SELECT 
product_key, 
COUNT(*) AS duplicate_count
FROM gold.dim_products 
GROUP BY product_key 
HAVING COUNT(*) >1;

-- =======================================================================================
-- Checking 'gold.fact_sales'
-- =======================================================================================
-- Check the data model connectivity between fact and dimensions
-- Expectation: No results
SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
on p.product_key = f.product_key
WHERE c.customer_key IS NULL


