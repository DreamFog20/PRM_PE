# BÁO CÁO ỨNG DỤNG LẤY DỮ LIỆU TỪ NGUỒN PUBLIC

## 1. Thông Tin Ứng Dụng
- **Nền tảng:** Android (Flutter) / Web (Hỗ trợ demo)
- **Cơ sở dữ liệu:** SQLite (sqflite) lưu trữ cục bộ.
- **Tính năng đặc biệt nổi bật:** Đồng bộ dữ liệu Online/Offline từ API public, Quản lý danh sách Yêu thích thời gian thực qua State Management (Provider), Chức năng Tìm kiếm (Search).

---

## 2. Cấu Trúc Cơ Sở Dữ Liệu (Database)

Ứng dụng sử dụng SQLite với 1 bảng chính để lưu trữ dữ liệu tải về từ API định dạng local và bảo toàn trạng thái yêu thích.

### Mô tả bảng chi tiết

**1. items**
- `id` (PK, INTEGER)
- `name` (TEXT) - Tên của item
- `description` (TEXT) - Thông tin chi tiết (được lấy từ trường email hoặc thông tin khác của public API)
- `isFavorite` (INTEGER) - Trạng thái yêu thích: 1 (Đã thích), 0 (Chưa thích)

*(Cấu trúc sơ đồ)*
> **[Ảnh 1: Cấu trúc cơ sở dữ liệu SQLite]**
┌───────────────────────┐
│        items          │
├───────────────────────┤
│ id (PK)               │
│ name (TEXT)           │
│ description (TEXT)    │
│ isFavorite (INTEGER)  │
└───────────────────────┘

---

## 3. Các Chức Năng Chính & Ảnh Demo

### 3.1. Trạng Thái Online/Offline (Screen 1)
- **Mô tả:** 
  - **Trạng thái Online:** Chức năng gọi API đến nguồn public (`69afe475c63dd197feba84f9.mockapi.io/users`) để lấy danh sách người dùng, sau đó đồng bộ hóa và tiến hành lưu trữ hoặc cập nhật vào SQLite local.
  - **Trạng thái Offline:** Ứng dụng đọc dữ liệu đã được lưu từ SQLite. Nếu người dùng chọn mà chưa có dữ liệu trong máy, ứng dụng sẽ xuất hiện AlertDialog thông báo lỗi và yêu cầu phải chạy trạng thái Online để nạp dữ liệu.
- *(Chèn ảnh màn hình Screen 1 và Thông báo)*
> **[Ảnh 2: Màn hình chọn Trạng Thái (Screen 1)]**

### 3.2. Hiển Thị Danh Sách Items (Screen 2)
- **Mô tả:** Hiển thị danh sách item lấy từ local database. Mỗi card hiển thị:
  - Tên (Title), Mô tả (Subtitle).
  - Avatar hình tròn chứa chữ cái đầu tiên của tên.
  - Icon Yêu Thích (hình ngôi sao). Nếu mục này đã được đánh dấu thích, màu nền card sẽ chuyển sang vàng nhạt (Amber 100) và icon sao sẽ được tô đậm nổi bật. Có thể click vào một item để xem chi tiết.
- *(Chèn ảnh Danh sách các Items)*
> **[Ảnh 3: Danh sách Items (Screen 2)]**

### 3.3. Xem/Sửa Chi Tiết (Screen 3)
- **Mô tả:** Hiển thị đầy đủ avatar cỡ lớn, tên và chi tiết của một item. Phía dưới có Button khổ lớn cho phép người dùng click để "Thêm Vào Yêu Thích" hoặc "Bỏ Yêu Thích". Sẽ cập nhật giá trị tương ứng vào database và thay đổi trạng thái UI đồng bộ qua các màn hình khác.
- *(Chèn ảnh chi tiết item tương ứng)*
> **[Ảnh 4: Chi tiết Item (Screen 3)]**

### 3.4. Danh Sách Đã Lưu (Screen 4)
- **Mô tả:** Màn hình phân loại những thẻ nhớ đã được "Thích" (`isFavorite = 1`). Người dùng nếu thao tác bỏ thích trực tiếp tại đây, item sẽ lập tức xóa hiển thị ra khỏi màn hình do sử dụng state management động.
- *(Chèn ảnh màn hình danh sách đã lưu)*
> **[Ảnh 5: Danh Sách Đã Lưu (Screen 4)]**

### 3.5. Chức Năng Tìm Kiếm (Search)
- **Mô tả:** Được đính kèm tại AppBar của Screen 2 và 4. Bằng cách ấn vào Icon kính lúp, AppBar sẽ chuyển sang chế độ gõ TextInput. Danh sách tự động lọc thông tin theo chuỗi input vừa nhập trùng với Tên hoặc Mô tả của item.

---

## 4. Trải Nghiệm & Giao Diện (UI/UX)
- Giao diện xây dựng theo chuẩn **Material Design 3**, thiết kế tinh tế dạng các box có bo góc (Radius). Khung nền và thẻ sử dụng hệ màu tươi sáng Blue Accent / Amber.
- Thao tác nhanh nhẹn, State management (qua Provider) đảm nhiệm load giao diện trên Screen 2 và Screen 4 ngay lập tức khi DB thay đổi, không hề có độ trễ phải load lại trang.
- Có hộp thoại (AlertDialog) và thanh bật lên (SnackBar) để hiển thị Feedback người dùng khi Tải thành công hay có Lỗi phát sinh.
- Cam kết ứng dụng không có Lỗi biên dịch.

---

## 5. File Chạy Demo Kèm Theo
- **Video / File Ảnh Demo:** `demo.webp` đi kèm ngay ngoài gốc thư mục source code, trình diễn chuỗi thao tác thực tế suốt tất cả màn hình (Tải API -> Hiển thị list -> Search list -> Click Item -> Yêu thích / Bỏ yêu thích -> Vào Đã lưu kiểm tra).
