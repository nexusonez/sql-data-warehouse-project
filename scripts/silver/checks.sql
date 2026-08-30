-- Check for Nulls or Duplicates in Primary Key

SELECT cst_id, count(*) FROM bronze.crm_cust_info GROUP BY cst_id HAVING COUNT(*) > 1 OR cst_id IS NULL

SELECT cst_id FROM bronze.crm_cust_info WHERE cst_id = 29466;
-- Remove duplicates in the primary key by getting the latest updated date for customer info
SELECT * FROM(
SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last FROM bronze.crm_cust_info
) t WHERE flag_last = 1;