use DataWareHouse
-- CTRL + H để hiện Replace => thay bronze thành silver

if OBJECT_ID('silver.crm_cust_info', 'U') is not null
	drop table silver.crm_cust_info;
Go	
Create Table silver.crm_cust_info(
	cst_id INT,
	cst_key Nvarchar(50),
	cst_firstname Nvarchar(50),
	cst_lastname Nvarchar(50),
	cst_material_status Nvarchar(50),
	cst_gndr Nvarchar(50),
	cst_create_date Date,
	dwh_create_date Datetime2 Default GETDATE()
);
Go

if OBJECT_ID('silver.crm_prd_info', 'U') is not null
	drop table silver.crm_prd_info;
Go
Create Table silver.crm_prd_info(
	prd_id INT,
	cat_id Nvarchar(50),
	prd_key Nvarchar(50),
	prd_nm Nvarchar(50),
	prd_cost INT,
	prd_line Nvarchar(50),
	prd_start_dt Date,
	prd_end_dt Date,
	dwh_create_date Datetime2 Default GETDATE()
);
Go

if OBJECT_ID('silver.crm_sales_details', 'U') is not null
	drop table silver.crm_sales_details;
Go
Create Table silver.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prd_key Nvarchar(50),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date Datetime2 Default GETDATE()
);
Go

if OBJECT_ID('silver.erp_loc_a101', 'U') is not null
	drop table silver.erp_loc_a101;
Go
Create Table silver.erp_loc_a101 (
	cid Nvarchar(50),
	cntry Nvarchar(50),
	dwh_create_date Datetime2 Default GETDATE()
);
Go

if OBJECT_ID('silver.erp_cust_az12', 'U') is not null
	drop table silver.erp_cust_az12;
Go
Create Table silver.erp_cust_az12 (
	cid Nvarchar(50),
	bdate Date,
	gen Nvarchar(50),
	dwh_create_date Datetime2 Default GETDATE()
);
Go

if OBJECT_ID('silver.erp_px_cat_g1v2', 'U') is not null
	drop table silver.erp_px_cat_g1v2;
Go
Create Table silver.erp_px_cat_g1v2 (
	id Nvarchar(50),
	cat Nvarchar(50),
	subcat Nvarchar(50),
	maintenance Nvarchar(50),
	dwh_create_date Datetime2 Default GETDATE()
);
Go
