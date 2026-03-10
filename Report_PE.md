# Báo Cáo Bài Thực Hành PE (Môn PRM392 - Lớp SE1828)

**Môn học:** PRM392 (Lập trình ứng dụng di động)  
**Lớp:** SE1828  
**Đề bài:** Ứng dụng quản lý item từ nguồn public (Online/Offline, Yêu thích, Tìm kiếm)

---

## 1. Giới thiệu chức năng

Ứng dụng đáp ứng đầy đủ yêu cầu của đề bài với các Screen như sau:

- **Screen 1 (Khởi động - Trạng thái Online/Offline):**
  - Giao diện cung cấp hai tính năng: **Online** và **Offline**.
  - **Online:** Khi nhấn, ứng dụng thực hiện call API lấy dữ liệu thực tế từ `jsonplaceholder.typicode.com/users` và đồng bộ (lưu trữ) vào **SQLite** của thiết bị. Nếu đã có thì cập nhật mới dữ liệu.
  - **Offline:** Ứng dụng đọc dữ liệu từ local. Nếu chưa có dữ liệu local, ứng dụng sẽ có thông báo đỏ yêu cầu người dùng phải thực hiện trạng thái Online trước.
  
- **Screen 2 (Danh sách Items):**
  - Hiển thị danh sách các item được tải về, mỗi item kèm theo Avatar (icon đại diện bằng chữ cái đầu) và icon "hình sao" thể hiện trạng thái Yêu thích.
  - Những item đã được yêu thích sẽ có icon sáng lên và được tô nền phân biệt (màu vàng nhạt/amber 100).
  - Thanh AppBar có thanh trạng thái Tìm Kiếm (Search) để tìm kiếm theo tên các item.

- **Screen 3 (Chi Tiết Item):**
  - Cung cấp mô tả chi tiết của từng item. Chứa nút lớn cho phép người dùng thay đổi trạng thái "Thêm Vào Yêu Thích" hoặc "Bỏ Yêu Thích".

- **Screen 4 (Danh sách Đã Lưu):**
  - Nơi liệt kê danh sách các item đã được đánh dấu thích.
  - Cung cấp tính năng thay đổi "Yêu Thích", ngay khi bỏ yêu thích, mục đó sẽ lập tức biến mất khỏi Screen này mà không cần tải lại trang.
  - Vẫn hỗ trợ tính năng Search chung tương tự Screen 2.

## 2. Giao diện (Màu sắc và Thẩm mỹ)

- Ứng dụng thiết kế theo **Material Design 3**, với tông màu chủ đạo là xanh (Blue Accent) và vàng nhạt (Amber) tạo cảm giác dễ chịu.
- Nền màn hình được tinh chỉnh để tôn các **Card** thành viên.
- Có đầy đủ các Notification dialog, SnackBar và Loading indicator (Spinner) khi tải dữ liệu đồng bộ mạng, tạo nên UX thân thiện, tối ưu, đảm bảo **không có bất kỳ lỗi vặt nào (Crash/Exception).**

## 3. Kiến Trúc Database và Source Code

- **Ngôn ngữ & Framework:** Nền tảng Flutter / Dart.
- **Database (SQLite qua plugin `sqflite`):**
  Tạo bảng `items` có cấu trúc:
  ```sql
  CREATE TABLE items(
    id INTEGER PRIMARY KEY,
    name TEXT,
    description TEXT,
    isFavorite INTEGER
  )
  ```
- **State Management:** Mô hình **Provider** thông qua `AppProvider` giúp đồng bộ dữ liệu giữa tất cả Screening - nếu đổi "Yêu thích" ở Screen 3 thì khi trở về Screen 2, màu và icon của card sẽ lập tức thay đổi!

## 4. Hình Ảnh & Demo Thực Tế

> Vui lòng xem tệp video thao tác trực tiếp (`demo.webp` kèm theo trong thư mục máy!) ghi nhận mọi luồng chạy của ứng dụng, chứng minh ứng dụng không phát sinh lỗi trong quá trình sử dụng.

*(Video trình chiếu quá trình khởi động, bấm tải từ mạng online, xem danh sách và lọc tìm kiếm, thêm vào yêu thích và chuyển trang)*

![Demo Ứng Dụng Đang Chạy](demo.webp)

---
*Báo cáo được hoàn thiện theo đúng tài liệu yêu cầu đối với bài kiểm tra PE thực hành.*
