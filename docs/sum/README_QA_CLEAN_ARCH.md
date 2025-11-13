# Hỏi đáp Clean Architecture Flutter (Q&A)

## 1. Entity là gì? Dùng để làm gì?

- Entity là class đại diện cho dữ liệu nghiệp vụ (business logic) của app, không phụ thuộc API, DB, UI.
- Dùng để truyền dữ liệu giữa các tầng (usecase, repository, UI).

## 2. Entity khác gì DTO?

- Entity: Dùng cho nghiệp vụ, chỉ chứa trường cần thiết cho logic app.
- DTO: Dùng để truyền dữ liệu với API (request/response), có thể khác tên trường, kiểu dữ liệu.

## 3. Module nào dùng entity?

- Domain: usecase, repository interface.
- Data: repository impl (convert model → entity).
- Presentation: provider, UI (hiển thị entity).

## 4. Luồng dữ liệu từ UI đến API và ngược lại?

- UI → Usecase → Repository (interface) → RepositoryImpl → DataSource → API
- API trả về JSON → DTO/model → RepositoryImpl convert sang entity → Usecase → UI

## 5. Usecase là gì? Có phải data/model không?

- Không. Usecase là class chứa logic nghiệp vụ (ví dụ: login, register), nhận input, trả về entity.

## 6. Repository interface và implement khác gì nhau?

- Interface: Định nghĩa các hàm nghiệp vụ, không có code thực thi.
- Implement: Thực thi chi tiết, gọi API, convert dữ liệu, mapping model ↔ entity.

## 7. Inject là gì? Ở đâu?

- Inject là truyền instance implement vào biến interface khi khởi tạo usecase/provider.
- Thường inject qua provider (Riverpod) hoặc DI container.

## 8. Provider kiểu này có quản lý state không?

- Provider inject dependency (repository, usecase...), không quản lý state app.
- State thực sự (user, loading, error) quản lý qua StateProvider, StateNotifierProvider...

## 9. Nếu viết thuần không DI thì sao?

- Tạo instance trực tiếp, truyền vào nhau bằng constructor, không cần provider hay DI.

## 10. Khi nào nên dùng Clean Architecture?

- Dự án lớn, nhiều dev, cần bảo trì lâu dài.
- Dự án nhỏ, MVP: Có thể đơn giản hóa, không cần tách tầng phức tạp.

## 11. Khi nào convert JSON sang entity?

- Khi repository impl nhận dữ liệu từ API (DTO/model), phải convert sang entity trước khi trả về usecase/UI.

## 12. Tóm tắt luồng inject và thực thi:

- UI gọi usecase → usecase gọi repository (interface) → instance implement được inject qua provider → thực thi code gọi API, convert dữ liệu, trả về entity cho UI.

---

**Tài liệu này tổng hợp các câu hỏi & trả lời về Clean Architecture Flutter trong dự án này.**
