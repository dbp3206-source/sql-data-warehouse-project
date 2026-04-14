 /*
================================================================================
DDL Script: Tạo các View cho Tầng Gold
================================================================================
Mục đích của Script:
    Script này dùng để tạo các View cho tầng Gold trong Data Warehouse.
    Tầng Gold đại diện cho các bảng Dimension và Fact cuối cùng (Star Schema).

    Mỗi View thực hiện các phép biến đổi và kết hợp dữ liệu từ tầng Silver
    để tạo ra một tập dữ liệu sạch, giàu thông tin và sẵn sàng cho mục đích kinh doanh.

Cách sử dụng:
    - Các View này có thể được truy vấn trực tiếp để phân tích và lập báo cáo.
================================================================================
*/

-- ==============================================================================
-- Create Dimension View: gold.dim_customers
-- ==============================================================================

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS 
SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS surrogate_customer_key, -- Khóa chính PK
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    ci.cst_material_status AS marital_status,
    CASE 
        WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr -- Bảng crm_cust_info là gốc nên lấy theo value bảng này
        ELSE COALESCE(ca.gen, 'N/A') -- Nếu crm là N/A thì lấy theo gen, N/A hoặc NULL cả 2 thì cho về N/A
    END AS gender,
    ca.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;
GO

/* ================== QUALITY CHECK & DEBUG LOGIC ==================
-- Check dup after join
SELECT cst_id, COUNT(*) AS check_dup FROM ( ... ) t GROUP BY cst_id HAVING COUNT(*) > 1;
-- Distinct gender check
SELECT DISTINCT ci.cst_gndr, ca.gen, CASE... END AS new_gen FROM ... ORDER BY 1, 2;
-- Basic Selection
SELECT * FROM gold.dim_customers;
SELECT DISTINCT gender FROM gold.dim_customers;
================================================================== */


-- ==============================================================================
-- Create Dimension View: gold.dim_products
-- ==============================================================================

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS surrogate_product_key, -- PK
    pn.prd_id AS product_id, 
    pn.prd_key AS product_number,     
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance AS maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS line,
    pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL; -- Filter out historical data, giữ lại thằng còn hiệu lực
GO

/* ================== QUALITY CHECK & DEBUG LOGIC ==================
-- Check dup after join
SELECT prd_key, COUNT(*) FROM ( ... ) t GROUP BY prd_key HAVING COUNT(*) > 1;
-- Basic Selection
SELECT * FROM gold.dim_products;
================================================================== */


-- ==============================================================================
-- Create Fact View: gold.fact_sales
-- ==============================================================================

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,
    pr.surrogate_product_key AS product_key, -- Chỉ hiển thị surrogate key (FK)
    cu.surrogate_customer_key AS customer_key,  -- Chỉ hiển thị surrogate key (FK)
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS ship_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number -- Join với key chung ở 2 bảng
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
GO

/* ================== QUALITY CHECK & DEBUG LOGIC ==================
-- Quality Check: Foreign Key Integrity (Dimension) ==> Check xem có join đc ko
SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers cu
    ON f.customer_key = cu.surrogate_customer_key
LEFT JOIN gold.dim_products pr
    ON f.product_key = pr.surrogate_product_key
WHERE cu.customer_id IS NULL OR pr.product_number IS NULL;
================================================================== */
