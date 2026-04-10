/*
===============================================================================
DDL Script: Tạo các bảng tầng Bronze (Bronze Tables)
===============================================================================
Mục đích của Script:
    Script này dùng để tạo các bảng trong schema 'bronze', đồng thời xóa bỏ các 
    bảng hiện có nếu chúng đã tồn tại. Chạy script này để định nghĩa lại 
    cấu trúc DDL của các bảng tầng 'bronze'.

Cách sử dụng:
    - Thực thi script này để thiết lập lại (reset) cấu trúc của tầng Bronze.
    - Đảm bảo rằng schema 'bronze' đã được tạo trước khi chạy script này.
===============================================================================
*/

use DataWareHouse
-- Luon kiem tra. Neu da thay thi xoa di de update lai
-- Dam bao trc khi nap vao Bronze ko con sot cac du lieu cu
if OBJECT_ID('bronze.crm_cust_info', 'U') is not null
	drop table bronze.crm_cust_info;
Go	
Create Table bronze.crm_cust_info(
	cst_id INT,
	cst_key Nvarchar(50),
	cst_firstname Nvarchar(50),
	cst_lastname Nvarchar(50),
	cst_material_status Nvarchar(50),
	cst_gndr Nvarchar(50),
	cst_create_date Date
);
Go

if OBJECT_ID('bronze.crm_prd_info', 'U') is not null
	drop table bronze.crm_prd_info;
Go
Create Table bronze.crm_prd_info(
	prd_id INT,
	prd_key Nvarchar(50),
	prd_nm Nvarchar(50),
	prd_cost INT,
	prd_line Nvarchar(50),
	prd_start_dt Datetime,
	prd_end_dt Datetime
);
Go

if OBJECT_ID('bronze.crm_sales_details', 'U') is not null
	drop table bronze.crm_sales_details;
Go
Create Table bronze.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prd_key Nvarchar(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);
Go

if OBJECT_ID('bronze.erp_loc_a101', 'U') is not null
	drop table bronze.erp_loc_a101;
Go
Create Table bronze.erp_loc_a101 (
	cid Nvarchar(50),
	cntry Nvarchar(50)
);
Go

if OBJECT_ID('bronze.erp_cust_az12', 'U') is not null
	drop table bronze.erp_cust_az12;
Go
Create Table bronze.erp_cust_az12 (
	cid Nvarchar(50),
	bdate Date,
	gen Nvarchar(50)
);
Go

if OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') is not null
	drop table bronze.erp_px_cat_g1v2;
Go
Create Table bronze.erp_px_cat_g1v2 (
	id Nvarchar(50),
	cat Nvarchar(50),
	subcat Nvarchar(50),
	maintenance Nvarchar(50)
);
Go
