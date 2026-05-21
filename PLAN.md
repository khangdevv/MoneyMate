# Kế hoạch & Bảng kiểm Triển khai Dự án MoneyMate

Dưới đây là chi tiết các bước thực hiện và checklist tiến độ trực tiếp cho dự án **MoneyMate (Flutter + Firebase + ExchangeRate API)**.

---

## 📋 BẢNG KIỂM TIẾN ĐỘ (CHECKLIST)

### 🛠️ Bước 1: Cấu hình môi trường & Thư viện
- [ ] Cập nhật các thư viện cần thiết trong `pubspec.yaml`
- [ ] Chạy `flutter pub get` để tải các package
- [ ] Liên kết Firebase Console và tạo file `lib/firebase_options.dart` (chạy `flutterfire configure`)

### 📦 Bước 2: Thiết lập các Model dữ liệu (`lib/models/`)
- [ ] `category_model.dart`: Cấu trúc danh mục (id, name, emoji, color, type, isDefault)
- [ ] `transaction_model.dart`: Cấu trúc giao dịch (id, type, amount, catId, note, hasReceipt, date, createdAt)
- [ ] `receipt_image_model.dart`: Cấu trúc lưu trữ ảnh đính kèm (id, storagePath, downloadUrl, uploadedAt)
- [ ] `exchange_rate_model.dart`: Cấu trúc lưu tỷ giá ngoại tệ

### 🔌 Bước 3: Phát triển các Lớp Dịch vụ (`lib/services/`)
- [ ] `auth_service.dart`: Đăng ký/đăng nhập qua Email + Google. Tự động seed 12 danh mục mặc định bằng Firestore `WriteBatch` khi đăng ký lần đầu.
- [ ] `firestore_service.dart`: CRUD giao dịch, danh mục, ngân sách tháng. Hỗ trợ Stream realtime.
- [ ] `storage_service.dart`: Chọn ảnh từ Camera/Gallery, nén ảnh xuống ~200KB bằng `flutter_image_compress` trước khi upload, xóa ảnh khi giao dịch bị xóa.
- [ ] `exchange_rate_service.dart`: Gọi API từ `exchangerate-api.com` để lấy tỷ giá mới nhất.

### 🧠 Bước 4: Thiết lập Quản lý trạng thái (`lib/providers/`)
- [ ] `auth_provider.dart`: Trạng thái đăng nhập của người dùng.
- [ ] `category_provider.dart`: Tải và lưu cache danh mục lên local bộ nhớ để lookup O(1) qua Map.
- [ ] `transaction_provider.dart`: Quản lý danh sách giao dịch, lọc theo tháng/năm, tính tổng thu/chi, quản lý ngân sách tháng & kiểm tra cảnh báo vượt mức.
- [ ] `exchange_provider.dart`: Lưu cache tỷ giá, thực hiện quy đổi tiền tệ hai chiều giữa 8 đồng tiền phổ biến và VND.

### 🚀 Bước 5: Cấu hình Khởi chạy Ứng dụng (`lib/main.dart`)
- [ ] Khởi tạo Firebase App.
- [ ] Cấu hình `MultiProvider`.
- [ ] Viết `AuthWrapper` điều hướng tự động giữa màn hình Đăng nhập/Đăng ký và Màn hình chính.

### 🎨 Bước 6: Thiết kế Giao diện người dùng (`lib/screens/` & `lib/widgets/`)
- [ ] **Màn hình Xác thực**: `login_screen.dart` & `register_screen.dart` (Giao diện hiện đại, nút đăng nhập Google bóng bẩy)
- [ ] **Màn hình Home**: `home_screen.dart` (Thẻ Số dư Gradient, thông báo đỏ cảnh báo nếu vượt ngân sách tháng, danh sách 10 giao dịch gần nhất)
- [ ] **Màn hình Thêm Giao dịch**: `add_transaction_screen.dart` (Toggle chọn thu/chi, bàn phím số định dạng tiền tệ realtime, chọn danh mục emoji, đính kèm ảnh)
- [ ] **Màn hình Lịch sử & Chi tiết**: `history_screen.dart` (Lọc theo tháng, vuốt để xóa giao dịch - Swipe-to-delete) & `transaction_detail_screen.dart` (Xem chi tiết, zoom ảnh hóa đơn)
- [ ] **Màn hình Thống kê**: `statistics_screen.dart` (Biểu đồ tròn phân bổ chi tiêu Pie Chart, biểu đồ cột so sánh thu/chi Bar Chart bằng `fl_chart`)
- [ ] **Màn hình Tỷ giá ngoại tệ**: `exchange_screen.dart` (Bảng tỷ giá 8 đồng tiền phổ biến so với VND, công cụ quy đổi 2 chiều realtime)
- [ ] **Màn hình Hồ sơ & Danh mục**: `profile_screen.dart` (Cài đặt ngân sách tháng, đăng xuất) & `category_screen.dart` (Xem danh sách danh mục, tạo danh mục mới với emoji/màu sắc HSL, xóa danh mục tự tạo)

### 🧪 Bước 7: Kiểm thử & Tinh chỉnh
- [ ] Chạy `flutter analyze` để rà soát lỗi cú pháp
- [ ] Kiểm tra khả năng đồng bộ thời gian thực qua Firestore Stream
- [ ] Kiểm tra nén ảnh & upload lên Firebase Storage
- [ ] Kiểm tra tỷ giá và tính năng quy đổi ngoại tệ

---

## 📐 KIẾN TRÚC THƯ MỤC CẦN XÂY DỰNG

```
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   ├── category_model.dart
│   ├── transaction_model.dart
│   ├── receipt_image_model.dart
│   └── exchange_rate_model.dart
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── storage_service.dart
│   └── exchange_rate_service.dart
├── providers/
│   ├── auth_provider.dart
│   ├── transaction_provider.dart
│   ├── category_provider.dart
│   └── exchange_provider.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home_screen.dart
│   ├── add_transaction_screen.dart
│   ├── transaction_detail_screen.dart
│   ├── history_screen.dart
│   ├── statistics_screen.dart
│   ├── category_screen.dart
│   ├── exchange_screen.dart
│   └── profile_screen.dart
└── widgets/
    ├── transaction_card.dart
    ├── category_item.dart
    ├── balance_card.dart
    ├── receipt_image_picker.dart
    ├── pie_chart_widget.dart
    └── bar_chart_widget.dart
```
