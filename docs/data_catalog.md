# Từ điển Dữ liệu (Data Catalog) cho Tầng Gold

## Tổng quan

Tầng Gold là lớp biểu diễn dữ liệu ở cấp độ nghiệp vụ, được cấu trúc nhằm hỗ trợ các mục đích phân tích và báo cáo. Nó bao gồm các **bảng danh mục (dimension tables)** và các **bảng sự kiện (fact tables)** phục vụ cho các chỉ số kinh doanh cụ thể.

---

### 1. gold.dim_customers
* **Mục đích:** Lưu trữ thông tin chi tiết của khách hàng, được làm giàu thêm bằng các dữ liệu nhân khẩu học và địa lý.
* **Chi tiết các cột:**

| Tên Cột | Kiểu Dữ Liệu | Mô tả |
| :--- | :--- | :--- |
| `customer_key` | INT | Khóa thay thế (Surrogate key) định danh duy nhất cho mỗi bản ghi khách hàng trong bảng dimension. |
| `customer_id` | INT | Mã định danh dạng số duy nhất được gán cho mỗi khách hàng. |
| `customer_number` | NVARCHAR(50) | Mã định danh dạng chữ và số đại diện cho khách hàng, dùng để theo dõi và đối chiếu. |
| `first_name` | NVARCHAR(50) | Tên (First name) của khách hàng, được ghi nhận trong hệ thống. |
| `last_name` | NVARCHAR(50) | Họ (Last name) của khách hàng. |
| `country` | NVARCHAR(50) | Quốc gia cư trú của khách hàng (ví dụ: 'Australia'). |
| `marital_status` | NVARCHAR(50) | Tình trạng hôn nhân của khách hàng (ví dụ: 'Married', 'Single'). |
| `gender` | NVARCHAR(50) | Giới tính của khách hàng (ví dụ: 'Male', 'Female', 'n/a'). |
| `birthdate` | DATE | Ngày sinh của khách hàng, định dạng YYYY-MM-DD (ví dụ: 1971-10-06). |
| `create_date` | DATE | Ngày và giờ bản ghi khách hàng được tạo trong hệ thống. |

---

### 2. gold.dim_products
* **Mục đích:** Cung cấp thông tin về các sản phẩm và các thuộc tính của chúng.
* **Chi tiết các cột:**

| Tên Cột | Kiểu Dữ Liệu | Mô tả |
| :--- | :--- | :--- |
| `product_key` | INT | Khóa thay thế (Surrogate key) định danh duy nhất cho mỗi bản ghi sản phẩm trong bảng dimension. |
| `product_id` | INT | Mã định danh duy nhất được gán cho sản phẩm để theo dõi và đối chiếu nội bộ. |
| `product_number` | NVARCHAR(50) | Mã cấu trúc dạng chữ và số đại diện cho sản phẩm, thường dùng để phân loại hoặc quản lý hàng tồn kho. |
| `product_name` | NVARCHAR(50) | Tên mô tả của sản phẩm, bao gồm các chi tiết chính như loại, màu sắc và kích cỡ. |
| `category_id` | NVARCHAR(50) | Mã định danh duy nhất cho danh mục của sản phẩm, liên kết đến phân loại cấp cao hơn. |
| `category` | NVARCHAR(50) | Phân loại rộng hơn của sản phẩm (ví dụ: Bikes, Components) để nhóm các mặt hàng liên quan. |
| `subcategory` | NVARCHAR(50) | Phân loại chi tiết hơn của sản phẩm nằm trong danh mục, chẳng hạn như loại hình sản phẩm. |
| `maintenance_required` | NVARCHAR(50) | Cho biết sản phẩm có yêu cầu bảo trì hay không (ví dụ: 'Yes', 'No'). |
| `cost` | INT | Chi phí hoặc giá gốc của sản phẩm, tính bằng đơn vị tiền tệ. |
| `product_line` | NVARCHAR(50) | Dòng sản phẩm hoặc chuỗi (series) cụ thể mà sản phẩm thuộc về (ví dụ: Road, Mountain). |
| `start_date` | DATE | Ngày sản phẩm bắt đầu được mở bán hoặc đưa vào sử dụng. |

---

### 3. gold.fact_sales
* **Mục đích:** Lưu trữ dữ liệu giao dịch bán hàng phục vụ cho mục đích phân tích.
* **Chi tiết các cột:**

| Tên Cột | Kiểu Dữ Liệu | Mô tả |
| :--- | :--- | :--- |
| `order_number` | NVARCHAR(50) | Mã định danh dạng chữ và số duy nhất cho mỗi đơn đặt hàng (ví dụ: 'SO54496'). |
| `product_key` | INT | Khóa thay thế (Surrogate key) liên kết đơn hàng với bảng danh mục sản phẩm (dim_products). |
| `customer_key` | INT | Khóa thay thế (Surrogate key) liên kết đơn hàng với bảng danh mục khách hàng (dim_customers). |
| `order_date` | DATE | Ngày đặt hàng. |
| `shipping_date` | DATE | Ngày đơn hàng được giao cho khách. |
| `due_date` | DATE | Ngày đến hạn thanh toán của đơn hàng. |
| `sales_amount` | INT | Tổng giá trị tiền tệ của mặt hàng bán ra, tính bằng số nguyên (ví dụ: 25). |
| `quantity` | INT | Số lượng sản phẩm được đặt cho mặt hàng đó (ví dụ: 1). |
| `price` | INT | Giá bán trên mỗi đơn vị sản phẩm cho mặt hàng đó, tính bằng số nguyên (ví dụ: 25). |
