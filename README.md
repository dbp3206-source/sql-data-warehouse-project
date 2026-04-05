# sql-data-warehouse-project
📊 Modern Data Warehouse Project with SQL Server


📝 Giới thiệu: 
Dự án này tập trung vào việc xây dựng một hệ thống Data Warehouse hiện đại sử dụng SQL Server. Quy trình đi từ việc xử lý dữ liệu thô (Raw Data), xây dựng luồng ETL (Extract - Transform - Load), mô hình hóa dữ liệu (Data Modeling) theo chuẩn Star Schema và thực hiện các phân tích chuyên sâu (Advanced Analytics).

Mục tiêu: Chuyển đổi dữ liệu phân mảnh từ hệ thống ERP và CRM thành nguồn tri thức duy nhất (Single Source of Truth) để hỗ trợ ra quyết định kinh doanh.

🏗️ Kiến trúc hệ thống (Data Architecture)
Dự án áp dụng kiến trúc Medallion Architecture (Kiến trúc Huy chương) để quản lý vòng đời dữ liệu:

Bronze Layer (Raw): Lưu trữ dữ liệu gốc từ các file CSV dưới dạng bảng Heap để tối ưu tốc độ nạp.

Silver Layer (Cleansed): Thực hiện Data Cleansing, chuẩn hóa định dạng và áp dụng các quy tắc Business Logic.

Gold Layer (Curated): Mô hình hóa dữ liệu theo dạng Star Schema (Fact & Dimension tables) sẵn sàng cho báo cáo.

🛠️ Công cụ & Công nghệ
Database: SQL Server (T-SQL)

Management: SQL Server Management Studio (SSMS)

Data Modeling: Star Schema (Kimball Methodology)

Documentation: Draw.io (Sơ đồ luồng), Notion (Quản lý tiến độ)

🚀 Quy trình thực hiện (Workflow)
1. Extraction (Trích xuất)
Sử dụng phương pháp Full Extract để đưa dữ liệu từ các tệp datasets/ vào lớp Bronze.

Kỹ thuật: File Parsing & Bulk Insert.

2. Transformation (Biến đổi)
Làm sạch: Xử lý giá trị NULL, xóa trùng lặp, chuẩn hóa kiểu dữ liệu.

Tích hợp: Kết hợp dữ liệu từ hai nguồn ERP và CRM để có cái nhìn toàn diện về khách hàng.

Naming Convention: Tuân thủ quy tắc đặt tên bảng (crm_, erp_, dim_, fact_).

3. Loading & Modeling (Nạp & Mô hình hóa)
Áp dụng kỹ thuật Truncate & Insert cho các bảng Fact.

Quản lý thay đổi dữ liệu với SCD Type 1 (Ghi đè).

Thiết kế mô hình Star Schema:

Fact Tables: fact_sales

Dimension Tables: dim_customers, dim_products, dim_date.

📈 Phân tích dữ liệu (Analytics)
Sau khi xây dựng xong kho dữ liệu, dự án thực hiện các câu hỏi phân tích như:

Customer Intelligence: Phân loại khách hàng theo khu vực và hành vi mua hàng.

Product Performance: Xác định top sản phẩm bán chạy nhất theo từng quý.

Window Functions: Sử dụng RANK() và LAG() để tính toán mức tăng trưởng doanh thu so với tháng trước.

📁 Cấu trúc thư mục
sql-data-warehouse-project/
├── datasets/           # Dữ liệu thô (CSV)
├── scripts/            # Script SQL thực thi
│   ├── bronze/         # DDL tạo bảng lớp Bronze
│   ├── silver/         # DML làm sạch dữ liệu
│   └── gold/           # Tạo View và mô hình Star Schema
├── docs/               # Sơ đồ thiết kế & Yêu cầu
└── README.md           # Hướng dẫn dự án
👨‍💻 Cách chạy dự án
Clone repository về máy.

Mở SSMS và chạy các script trong thư mục scripts/bronze/ để tạo cấu trúc.

Import các file trong datasets/ vào các bảng tương ứng.

Chạy tuần tự các script silver và gold để hoàn tất kho dữ liệu.
