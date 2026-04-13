/*
===============================================================================
Quality Checks
===============================================================================

Mục đích của Script:
Script này thực hiện nhiều bước kiểm tra chất lượng dữ liệu nhằm đảm bảo
tính nhất quán (consistency), độ chính xác (accuracy) và chuẩn hóa dữ liệu
trong các schema thuộc tầng 'silver'. Các kiểm tra bao gồm:

- Kiểm tra khóa chính bị NULL hoặc trùng lặp.
- Kiểm tra khoảng trắng không mong muốn trong các trường chuỗi.
- Kiểm tra chuẩn hóa và tính nhất quán của dữ liệu.
- Kiểm tra các khoảng ngày hoặc thứ tự ngày không hợp lệ.
- Kiểm tra tính nhất quán dữ liệu giữa các trường liên quan.

Lưu ý khi sử dụng:
- Chạy các kiểm tra này sau khi đã nạp dữ liệu vào Silver Layer.
- Kiểm tra và xử lý các sai lệch dữ liệu nếu được phát hiện trong quá trình kiểm tra.

===============================================================================
*/
-- ===============================================================
-- Checking 'silver.crm_cust_info'
-- ===============================================================

-- Note: Chạy lại DDL -> Clean -> rồi mới Check 
-- HOẶC dùng luôn TRUNCATE rồi mới INSERT ở bước Clean
-- Dùng CTRL + Shift + R để làm mới cache ==> tránh lỗi đỏ dù query vẫn chạy được

-- # Check for NULLs or Dups in the Primary Key
SELECT
    cst_id,
    COUNT(*) AS cnt_cst_id
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- # Check for unwanted spaces in STRING values
SELECT
    cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT
    cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);


-- # Check the consistency of values in low cardinality columns
-- Check xem có bao nhiêu biến thể của cùng một nội dung => quy về một kiểu

SELECT DISTINCT
    cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT
    cst_material_status
FROM silver.crm_cust_info;


-- # Re-Check
SELECT *
FROM silver.crm_cust_info;

-- ===============================================================
-- Checking 'silver.crm_prd_info'
-- ===============================================================

-- Note: DÙNG TRUNCATE RỒI MỚI INSERT Ở CLEAN
-- Dùng CTRL + Shift + R để làm mới cache ==> ko bị lỗi đỏ dù vẫn chạy đc
-- Lúc đầu để silver để check xem có lỗi ko ==> sau đổi thành silver để check sửa ok chưa


-- # Check for NULLs or Dups in the Primary Key
SELECT
    prd_id,
    COUNT(*) AS cnt_prd_id
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;


-- # Check for unwanted spaces in STRING values
SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);


-- # Check for NULLS or Negative Numbers
SELECT
    prd_id,
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;


-- # Check the consistency of values in low cardinality columns
-- Check xem có bnhieu biến thể của cùng 1 nội dung => quy về 1 kiểu
SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;


-- # Check for Invalid Date Orders
-- ==> end_date đang xét = start_date của ngày đằng sau nó - 1
SELECT
    prd_id
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt
AND prd_end_dt IS NOT NULL;


-- # Re-Check
SELECT *
FROM silver.crm_prd_info;

-- ===============================================================
-- Checking 'silver.crm_sales_details'
-- ===============================================================


-- # Check Logic: Order Date must always be earlier than shipping date or due date
SELECT
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;


-- # Check Data Consistency: Between Sales, Quantity and Price 
-- && Values must not be NULL, zero or negative
/*
Rules:
1. If Sales is negative, zero, or NULL → derive it using Quantity * Price.
2. If Price is zero or NULL → calculate it using Sales / Quantity.
3. If Price is negative → convert it to a positive value.

==> Nhân với ABS để phòng trường hợp sai ở cả 2 chỗ Sales và Price cùng lúc.
Quantity được giả định là không bị sai.
*/

SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY 
    sls_sales,
    sls_quantity,
    sls_price;


-- # Re-Check
SELECT *
FROM silver.crm_sales_details;

-- ===============================================================
-- Checking 'silver.erp_cust_az12'
-- ===============================================================


-- # Check Out-of-Range Dates
SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();


-- # Check Data Standardization & Consistency
SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;


-- # Re-Check
SELECT *
FROM silver.erp_cust_az12;

-- ===============================================================
-- Checking 'silver.erp_loc_a101'
-- ===============================================================


-- # Check Data Standardization and Consistency
SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101;


-- # Re-Check
SELECT *
FROM silver.erp_loc_a101;

-- ===============================================================
-- Checking 'silver.erp_px_cat_g1v2'
-- ===============================================================


-- # Check for Unwanted Spaces
SELECT
    *
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat)
   OR subcat != TRIM(subcat)
   OR maintenance != TRIM(maintenance);


-- # Re-Check
SELECT *
FROM silver.erp_px_cat_g1v2;
