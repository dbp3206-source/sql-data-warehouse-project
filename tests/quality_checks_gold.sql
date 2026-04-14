/*
===============================================================================
Kiểm tra Chất lượng Dữ liệu (Quality Checks)
===============================================================================
Mục đích Script:
    Script này thực hiện các bước kiểm tra chất lượng nhằm xác định tính toàn vẹn, 
    nhất quán và độ chính xác của lớp dữ liệu Gold Layer. Các bước này đảm bảo:
    - Tính duy nhất của các khóa thay thế (surrogate keys) trong các bảng chiều (dimension tables).
    - Tính toàn vẹn tham chiếu giữa bảng sự kiện (fact tables) và bảng chiều.
    - Xác thực các mối quan hệ trong mô hình dữ liệu phục vụ cho mục đích phân tích.

Lưu ý khi sử dụng:
    - Cần điều tra và xử lý triệt để bất kỳ sai sót nào phát hiện được trong quá trình kiểm tra.
===============================================================================
*/

-- ====================================================================
-- Checking 'gold.dim_customers'
-- ====================================================================
-- Check for Uniqueness of Customer Key in gold.dim_customers
-- Expectation: No results 
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.product_key'
-- ====================================================================
-- Check for Uniqueness of Product Key in gold.dim_products
-- Expectation: No results 
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- ====================================================================
-- Checking 'gold.fact_sales'
-- ====================================================================
-- Check the data model connectivity between fact and dimensions
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL  
