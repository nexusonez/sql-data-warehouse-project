CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	DECLARE @procedure_start_time DATETIME, @procedure_end_time DATETIME;
	BEGIN TRY
		
		PRINT '=====================================';
		PRINT 'Loading Bronze Layer';
		PRINT '=====================================';
		/*---------------------------------------------------------------------------------------------------------*/

		PRINT '-------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '-------------------------------------';

		SET @procedure_start_time = GETDATE();

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;
		PRINT '>> Inserting Data Into: bronze.crm_cust_info';

		BULK INSERT bronze.crm_cust_info
		FROM "C:\xampp\htdocs\sql-data-warehouse-project\datasets\source_crm\cust_info.csv"
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------';
		--SELECT * FROM bronze.crm_cust_info;
		--SELECT COUNT(*) FROM bronze.crm_cust_info;

		/*
		Row count in file: 18495 in the video they have 18494 but for me i have 1 extra for no reason (,A01Ass,,,,,)
		Count in SQL: 18493
		*/

		/*---------------------------------------------------------------------------------------------------------*/
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>> Inserting Data Into: bronze.crm_prd_info';
		BULK INSERT bronze.crm_prd_info
		FROM "C:\xampp\htdocs\sql-data-warehouse-project\datasets\source_crm\prd_info.csv"
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'; /** to check if there is any bottlenecks**/
		PRINT '-------------------------------------';
		--SELECT * FROM bronze.crm_prd_info;
		--SELECT COUNT(*) FROM bronze.crm_prd_info;

		/*
		Row count in file: 399 - header - blank row = 397
		Count in SQL: 397
		*/

		/*---------------------------------------------------------------------------------------------------------*/	
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		PRINT '>> Inserting Data Into: bronze.crm_sales_details';
		BULK INSERT bronze.crm_sales_details
		FROM "C:\xampp\htdocs\sql-data-warehouse-project\datasets\source_crm\sales_details.csv"
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------';
		--SELECT * FROM bronze.crm_sales_details;
		--SELECT COUNT(*) FROM bronze.crm_sales_details;

		/*
		Row count in file: 60400 - header - blank row = 60398
		Count in SQL: 60398
		*/

		/*---------------------------------------------------------------------------------------------------------*/
		PRINT '-------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '-------------------------------------';
		
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;
		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';
		BULK INSERT bronze.erp_cust_az12
		FROM "C:\xampp\htdocs\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv"
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------';
		--SELECT * FROM bronze.erp_cust_az12;
		--SELECT COUNT(*) FROM bronze.erp_cust_az12;

		/*
		Row count in file: 18485
		Count in SQL: 18483
		*/

		/*---------------------------------------------------------------------------------------------------------*/
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;
		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
		BULK INSERT bronze.erp_loc_a101
		FROM "C:\xampp\htdocs\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv"
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------';
		--SELECT * FROM bronze.erp_loc_a101;
		--SELECT COUNT(*) FROM bronze.erp_loc_a101;

		/*
		Row count in file: 18486
		Count in SQL: 18484
		*/

		/*---------------------------------------------------------------------------------------------------------*/
		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;
		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM "C:\xampp\htdocs\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv"
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '-------------------------------------';
		--SELECT * FROM bronze.erp_px_cat_g1v2;
		--SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;

		/*
		Row count in file: 38
		Count in SQL: 37
		*/

		/*---------------------------------------------------------------------------------------------------------*/
		SET @procedure_end_time = GETDATE();
		PRINT '>> Whole Batch Load Duration: ' + CAST(DATEDIFF(second, @procedure_start_time, @procedure_end_time) AS NVARCHAR) + ' seconds';
		END TRY
		BEGIN CATCH
			PRINT '========================'
			PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
			PRINT 'Error Message' + ERROR_MESSAGE();
			PRINT 'Error Number' + CAST (ERROR_NUMBER() AS NVARCHAR);
			PRINT 'Error Number' + CAST (ERROR_STATE() AS NVARCHAR);
			PRINT '========================'
		END CATCH

END;