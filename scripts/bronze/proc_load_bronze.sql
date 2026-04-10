/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Mục đích của Script:
    Stored Procedure này thực hiện nạp dữ liệu vào schema 'bronze' từ các tệp 
    CSV bên ngoài. 
    Các hành động cụ thể bao gồm:
    - Truncate (xóa sạch dữ liệu) các bảng bronze trước khi nạp mới.
    - Sử dụng lệnh 'BULK INSERT' để nạp dữ liệu từ các tệp CSV vào bảng bronze.

Tham số:
    Không có.
    Stored Procedure này không nhận tham số đầu vào và không trả về giá trị.

Ví dụ sử dụng:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time Datetime, @end_time Datetime, @batch_start_time Datetime, @batch_end_time Datetime; 
	-- Tao Variables ==> Track ETL Duration
	BEGIN TRY
	    SET @batch_start_time = GETDATE();
		PRINT '=======================================================';
		PRINT 'LOADING BRONZE LAYER';
		PRINT '=======================================================';
	
		PRINT '*******************************************************';
		PRINT 'LOADING CRM TABLES';
		PRINT '*******************************************************';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Tables: bronze.crm_cust_info'
		TRUNCATE TABLE bronze.crm_cust_info; -- Reset table về empty
		PRINT '>> Inserting Data Into: bronze.crm_cust_info'
		BULK INSERT bronze.crm_cust_info
		From 'C:\Users\Bao Phuc\Documents\SQL Server Management Studio 22\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
		With(
			FIRSTROW = 2, -- Từ dòng thứ 2 trở đi mới là giá trị (mở bằng Notepad)
			FIELDTERMINATOR = ',', -- Các cột dữ liệu ngăn cách bởi dấu ,
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + Cast(DATEDIFF(second,@start_time,@end_time) as  Nvarchar) + 'SECONDS';
		PRINT '----------------';
		-- Quality check: Check xem data có bị shift đi nhầm chỗ (ko ở đúng vị trí gốc) ko? 
		-- Có thể do dính dấu phẩy trong tên nên chia vị trí sai chẳng hạn
		--select * from bronze.crm_cust_info
		--select count(*) from bronze.crm_cust_info -- Check xem tổng số row có = số row trong bản gốc ko

		SET @START_TIME = GETDATE();
		PRINT '>> Truncating Tables: bronze.crm_prd_info'
		TRUNCATE TABLE bronze.crm_prd_info;
		PRINT '>> Inserting Data Into: bronze.crm_prd_info'
		BULK INSERT bronze.crm_prd_info
		From 'C:\Users\Bao Phuc\Documents\SQL Server Management Studio 22\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
		With(
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',', 
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + Cast(DATEDIFF(second,@start_time,@end_time) as  Nvarchar) + 'SECONDS';
		PRINT '----------------';

		SET @START_TIME = GETDATE();
		PRINT '>> Truncating Tables: bronze.crm_sales_details'
		TRUNCATE TABLE bronze.crm_sales_details; 
		PRINT '>> Inserting Data Into: bronze.crm_sales_details'
		BULK INSERT bronze.crm_sales_details
		From 'C:\Users\Bao Phuc\Documents\SQL Server Management Studio 22\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
		With(
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',', 
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + Cast(DATEDIFF(second,@start_time,@end_time) as  Nvarchar) + 'SECONDS';
		PRINT '----------------';

		PRINT '*******************************************************';
		PRINT 'LOADING ERP TABLES';
		PRINT '*******************************************************';

		SET @START_TIME = GETDATE();
		PRINT '>> Truncating Tables: bronze.erp_loc_a101'
		TRUNCATE TABLE bronze.erp_loc_a101; 
		PRINT '>> Inserting Data Into: bronze.erp_loc_a101'
		BULK INSERT bronze.erp_loc_a101
		From 'C:\Users\Bao Phuc\Documents\SQL Server Management Studio 22\sql-data-warehouse-project-main\datasets\source_erp\loc_a101.csv'
		With(
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',', 
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + Cast(DATEDIFF(second,@start_time,@end_time) as  Nvarchar) + 'SECONDS';
		PRINT '----------------';

		SET @START_TIME = GETDATE();
		PRINT '>> Truncating Tables: bronze.erp_cust_az12'
		TRUNCATE TABLE bronze.erp_cust_az12; 
		PRINT '>> Inserting Data Into: bronze.erp_cust_az12'
		BULK INSERT bronze.erp_cust_az12
		From 'C:\Users\Bao Phuc\Documents\SQL Server Management Studio 22\sql-data-warehouse-project-main\datasets\source_erp\cust_az12.csv'
		With(
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',', 
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + Cast(DATEDIFF(second,@start_time,@end_time) as  Nvarchar) + 'SECONDS';
		PRINT '----------------';

		SET @START_TIME = GETDATE();
		PRINT '>> Truncating Tables: bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE bronze.erp_px_cat_g1v2; 
		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2'
		BULK INSERT bronze.erp_px_cat_g1v2
		From 'C:\Users\Bao Phuc\Documents\SQL Server Management Studio 22\sql-data-warehouse-project-main\datasets\source_erp\px_cat_g1v2.csv'
		With(
			FIRSTROW = 2, 
			FIELDTERMINATOR = ',', 
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT 'LOAD DURATION: ' + Cast(DATEDIFF(second,@start_time,@end_time) as  Nvarchar) + 'SECONDS';
		PRINT '----------------';

		SET @batch_end_time = GETDATE();

		PRINT '=======================================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '   - Total Load Duration: ' + Cast(Datediff(second, @batch_start_time,@batch_end_time) as Nvarchar) + 'SECONDS';
		PRINT '=======================================================';

	END TRY
	BEGIN CATCH  -- Dùng try and catch de kiem soat loi (error handling)
		PRINT '=======================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
		PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'ERROR LINE: ' + CAST(ERROR_LINE() AS NVARCHAR);
		PRINT 'ERROR PROCEDURE: ' + ISNULL(ERROR_PROCEDURE(), 'NONE');
		PRINT '=======================================================';
	END CATCH
END
--Execute bronze.load_bronze -- Tao 1 query khac va execute thi se tu load date vao table
