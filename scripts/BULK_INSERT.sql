/*---------------------------------------------------------------------------------------------------------*/
TRUNCATE TABLE bronze.crm_cust_info;
BULK INSERT bronze.crm_cust_info
FROM "C:\xampp\htdocs\sql-data-warehouse-project\datasets\source_crm\cust_info.csv"
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM bronze.crm_cust_info
SELECT COUNT(*) FROM bronze.crm_cust_info

/*
Row count in file: 18495 in the video they have 18494 but for me i have 1 extra for no reason (,A01Ass,,,,,)
Count in SQL: 18493
*/

/*---------------------------------------------------------------------------------------------------------*/
TRUNCATE TABLE bronze.crm_prd_info;
BULK INSERT bronze.crm_prd_info
FROM "C:\xampp\htdocs\sql-data-warehouse-project\datasets\source_crm\prd_info.csv"
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM bronze.crm_prd_info

/*
Row count in file: 18495
Count in SQL: 18493
*/


/*---------------------------------------------------------------------------------------------------------*/
BULK INSERT bronze.crm_sales_details
FROM "C:\xampp\htdocs\sql-data-warehouse-project\datasets\source_crm\sales_details.csv"
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM bronze.crm_sales_details
/*
Row count in file: 18495
Count in SQL: 18493
*/

/*---------------------------------------------------------------------------------------------------------*/
BULK INSERT bronze.erp_cust_az12
FROM "C:\xampp\htdocs\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv"
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM bronze.erp_cust_az12
/*
Row count in file: 18495
Count in SQL: 18493
*/

/*---------------------------------------------------------------------------------------------------------*/
BULK INSERT bronze.erp_loc_a101
FROM "C:\xampp\htdocs\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv"
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM bronze.erp_loc_a101
/*
Row count in file: 18495
Count in SQL: 18493
*/

/*---------------------------------------------------------------------------------------------------------*/
BULK INSERT bronze.erp_px_cat_g1v2
FROM "C:\xampp\htdocs\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv"
WITH(
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	TABLOCK
);

SELECT * FROM bronze.erp_px_cat_g1v2
/*
Row count in file: 18495
Count in SQL: 18493
*/

/*---------------------------------------------------------------------------------------------------------*/