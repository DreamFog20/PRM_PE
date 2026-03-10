# BÁO CÁO ỨNG DỤNG QUẢN LÝ SINH VIÊN

## 1. Thông Tin Ứng Dụng
- **Nền tảng:** Android (Flutter)
- **Cơ sở dữ liệu:** SQLite (sqflite) lưu trữ cục bộ.
- **Tính năng đặc biệt nổi bật:** Chụp hình (Camera), Bản đồ (TomTom Map), Geocoding, Đọc danh bạ (Contacts), Phân quyền Admin/User.

---

## 2. Cấu Trúc Cơ Sở Dữ Liệu (Database)

Ứng dụng sử dụng SQLite với 3 bảng chính. Đã bật tính năng `PRAGMA foreign_keys = ON` để đảm bảo toàn vẹn dữ liệu.

### Mô tả bảng chi tiết

**1. users**
- `id` (PK)
- `username`
- `password`
- `role`

**2. nganhs**
- `id` (PK)
- `name`

**3. sinhviens**
- `id` (PK)
- `user_id` (FK → users.id)
- `mssv`
- `name`
- `nganh_id` (FK → nganhs.id)
- `phone_number`
- `image_path`
- `latitude`
- `longitude`

*(Chèn ảnh Schema Database / ERD hoặc ảnh chụp code tạo bảng DB tại đây)*
> **[Ảnh 1: Cấu trúc cơ sở dữ liệu SQLite]**
┌─────────────────┐         ┌──────────────────────────────────────┐
│     users       │         │              sinhviens               │
├─────────────────┤         ├──────────────────────────────────────┤
│ id (PK, AUTO)   │◄────────│ id (PK, AUTO)                        │
│ username(UNIQUE)│         │ user_id (FK → users.id)              │
│ password        │         │ mssv                                 │
│ role            │         │ name                                 │
└─────────────────┘         │ nganh_id (FK → nganhs.id)            │
                            │ phone_number                         │
┌─────────────────┐         │ image_path                           │
│     nganhs      │         │ latitude                             │
├─────────────────┤         │ longitude                            │
│ id (PK, AUTO)   │◄────────│                                      │
│ name            │         └──────────────────────────────────────┘
└─────────────────┘

---

## 3. Các Chức Năng Chính & Ảnh Demo

### 3.1. Đăng Nhập & Đăng Ký (Có lưu Session)
- **Mô tả:** Người dùng có thể đăng nhập bằng tài khoản Đào Tạo (Admin) hoặc tự đăng ký tài khoản Sinh viên. Ứng dụng sử dụng **SharedPreferences** để lưu trạng thái đăng nhập (login_session), vai trò người dùng và hỗ trợ chức năng "Ghi nhớ đăng nhập", giúp tự động điều hướng khi mở lại ứng dụng.
- *(Chèn ảnh màn hình Login và màn hình Register)*
> **[Ảnh 2: Màn hình Login]**
> **[Ảnh 3: Màn hình Đăng ký]**

### 3.2. Quản Lý Danh Sách & Phân Quyền
- **Mô tả:** 
  - **Đào Tạo (Admin):** Thấy toàn bộ danh sách, có quyền Thêm/Sửa/Xóa Sinh viên và Ngành học.
  - **Sinh Viên:** Chỉ được xem và cập nhật thông tin của chính mình.
- *(Chèn ảnh danh sách hiển thị các Sinh viên và Ngành)*
> **[Ảnh 4: Danh sách Sinh Viên (Góc nhìn Đào Tạo)]**
> **[Ảnh 5: Quản lý Ngành Học]**

### 3.3. Xem/Sửa Chi Tiết & Chức Năng Camera
- **Mô tả:** Trong giao diện chi tiết, người dùng có thể nhấp vào ảnh đại diện để gọi chức năng Camera 📸 chụp và cập nhật avatar trực tiếp.
- *(Chèn ảnh chi tiết sinh viên và lúc đang mở Camera)*
> **[Ảnh 6: Trang Chi Tiết Sinh Viên (Nhấn vào Avatar để chụp ảnh)]**

### 3.4. Vị Trí Bản Đồ (Map & Geocoding)
- **Mô tả:** Tích hợp TomTom Map. Khi thêm mới/sửa địa chỉ bằng văn bản, App sẽ gọi API Nominatim tự động chuyển thành Tọa độ (Geocoding) để ghim đỏ (pin) chính xác lên bản đồ.
- *(Chèn ảnh Form nhập địa chỉ và Bản đồ hiển thị vị trí)*
> **[Ảnh 7: Form nhập địa chỉ và Bản đồ định vị ngay bên dưới]**

### 3.5. Trích Xuất Danh Bạ Điện Thoại
- **Mô tả:** Nút "Danh bạ" cho phép người dùng mở ứng dụng Contacts gốc của máy, chọn liên hệ và App sẽ tự động điền số điện thoại vào.
- *(Chèn ảnh lúc cấp quyền / đang chọn số từ danh bạ)*
> **[Ảnh 8: Tương tác mở danh bạ điền số điện thoại]**

---

## 4. Trải Nghiệm & Giao Diện (UI/UX)
- Giao diện Material Design 3, màu sắc hiện đại (Gradient).
- Các thao tác đi kèm hiệu ứng (Animation) chuyển động mượt, có bảng thông báo (SnackBar) xanh/đỏ rõ ràng khi thao tác Thành công hoặc Lỗi.

---

## 5. Tài Khoản Demo
- **Đào Tạo (Admin):** `admin` / `admin`
- **Sinh Viên:** *(Tạo mới một sinh viên và sử dụng username/pass tương ứng)*
