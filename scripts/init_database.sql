/*
===============================================================================
Khởi tạo Cơ sở dữ liệu và Các Schema (Lớp dữ liệu)
===============================================================================
Mục đích Script:
    Script này thực hiện kiểm tra và khởi tạo một Database mới có tên 'DataWarehouse'.
    Nếu Database này đã tồn tại, hệ thống sẽ xóa (Drop) và tạo lại mới hoàn toàn.
    Đồng thời, script cũng thiết lập 3 lớp dữ liệu (Schemas) bên trong Database gồm:
    'bronze' (Đồng), 'silver' (Bạc), và 'gold' (Vàng).

CẢNH BÁO:
    Việc chạy script này sẽ XÓA TOÀN BỘ Database 'DataWarehouse' nếu nó đã tồn tại.
    Tất cả dữ liệu trong Database sẽ bị mất vĩnh viễn và không thể khôi phục.
    Vui lòng thận trọng và đảm bảo bạn đã sao lưu dữ liệu cần thiết trước khi 
    thực thi script này.
===============================================================================
*/

-- Create Database 'Datawarehouse'
use master;
go
-- Drop and recreate the 'DataWareHouse' database ==> neu co roi thi xoa di va recreate, chua co thi tao o doan sau
if exists (select 1 from sys.databases where name = 'DataWareHouse')
begin
	alter Database DataWareHouse set Single_user with rollback immediate;
	drop database DataWareHouse;
end;
go

-- Create the 'DataWareHouse' database
create database DataWareHouse;
go

use DataWareHouse;
go

create schema bronze;
go -- seperate batches when working multiple statements
create schema silver;
go
create schema gold;
go
