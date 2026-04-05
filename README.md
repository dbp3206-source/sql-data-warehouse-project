# 📊 SQL Data Warehouse Project

## 📝 Giới thiệu
Dự án này tập trung vào việc xây dựng một hệ thống **Data Warehouse hiện đại** sử dụng SQL Server. Quy trình đi từ việc xử lý dữ liệu thô (Raw Data), xây dựng luồng **ETL (Extract - Transform - Load)**, mô hình hóa dữ liệu (Data Modeling) theo chuẩn **Star Schema** và thực hiện các phân tích chuyên sâu (Advanced Analytics).

> **Mục tiêu:** Chuyển đổi dữ liệu phân mảnh từ hệ thống ERP và CRM thành "Nguồn sự thật duy nhất" (Single Source of Truth) để hỗ trợ ra quyết định kinh doanh.

---

## 🏗️ Kiến trúc hệ thống (Data Architecture)
Dự án áp dụng kiến trúc **Medallion Architecture** (Kiến trúc Huy chương) để quản lý vòng đời dữ liệu:

1.  **Bronze Layer (Raw):** Lưu trữ dữ liệu gốc từ các file CSV dưới dạng bảng **Heap** để tối ưu tốc độ nạp (Full Load).
2.  **Silver Layer (Cleansed):** Thực hiện Data Cleansing, chuẩn hóa định dạng (Standardization) và áp dụng các quy tắc Business Logic.
3.  **Gold Layer (Curated):** Mô hình hóa dữ liệu theo dạng **Star Schema** (Fact & Dimension tables) sẵn sàng cho báo cáo và phân tích.

---

## 🛠️ Công cụ & Công nghệ
* **Database:** SQL Server (T-SQL)
* **Management:** SQL Server Management Studio (SSMS)
* **Data Modeling:** Star Schema (Kimball Methodology)
* **Methodology:** Medallion Architecture (Bronze - Silver - Gold)

---

## 🚀 Quy trình thực hiện (Workflow)

### 1. Extraction (Trích xuất)
* Sử dụng phương pháp **Full Extract** để đưa dữ liệu từ các tệp `.csv` vào lớp **Bronze**.
* Kỹ thuật: File Parsing & Bulk Insert vào các bảng Staging (Heap).

### 2. Transformation (Biến đổi)
* **Làm sạch (Cleansing):** Xử lý giá trị NULL, xóa trùng lặp, chuẩn hóa kiểu dữ liệu (Casting).
* **Tích hợp:** Kết hợp dữ liệu từ hai nguồn ERP và CRM để có cái nhìn toàn diện.
* **Quy tắc đặt tên:** Tuân thủ Naming Convention (`crm_`, `erp_` cho nguồn; `dim_`, `fact_` cho đích).

### 3. Loading & Modeling (Nạp & Mô hình hóa)
* Áp dụng kỹ thuật **Truncate & Insert** cho các bảng để đảm bảo dữ liệu luôn mới nhất.
* Quản lý thay đổi dữ liệu với **SCD Type 1** (Ghi đè thông tin cũ).
* Thiết kế mô hình Star Schema:
    * **Fact Tables:** `fact_sales` (Chứa các giao dịch và con số).
    * **Dimension Tables:** `dim_customers`, `dim_products`, `dim_date` (Chứa thông tin mô tả).

---

## 📈 Phân tích dữ liệu (Analytics)
Sau khi xây dựng xong kho dữ liệu, hệ thống cung cấp các báo cáo chuyên sâu sử dụng:
* **Window Functions:** Sử dụng `RANK()`, `DENSE_RANK()` để xếp hạng doanh thu.
* **Time Intelligence:** Tính toán tăng trưởng doanh thu theo tháng/quý bằng `LAG()` và `LEAD()`.
* **Aggregations:** Tổng hợp doanh số theo từng nhóm sản phẩm và khu vực khách hàng.

---

## 📁 Cấu trúc thư mục
```text
sql-data-warehouse-project/
├── datasets/           # Dữ liệu thô nguồn (CSV)
├── scripts/            # Script SQL thực thi theo từng lớp
│   ├── bronze/         # DDL tạo bảng và nạp dữ liệu thô
│   ├── silver/         # DML làm sạch và chuẩn hóa dữ liệu
│   └── gold/           # Tạo mô hình Star Schema (Fact/Dim)
├── docs/               # Sơ đồ thiết kế kiến trúc & Data Model
└── README.md           # Hướng dẫn chi tiết dự án
