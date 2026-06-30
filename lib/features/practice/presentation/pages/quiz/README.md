# Quiz Feature

Thư mục này chứa các màn hình và widgets liên quan đến tính năng "Quiz nhanh" trong phần Practice.

## Cấu trúc hiện tại

```
quiz/
├── quiz_topic_selection_page.dart  # Màn chọn topic để luyện quiz
├── quiz_play_page.dart              # Màn chơi quiz (hiện empty state)
└── README.md                        # File này

../widgets/
└── quiz_type_bottom_sheet.dart     # Bottom sheet chọn loại bài tập
```

## Flow

1. **PracticePage** (trang chính) → Click "Quiz nhanh"
2. **QuizTopicSelectionPage** → Hiển thị danh sách topics (sử dụng API đã có)
3. **QuizTypeBottomSheet** → Chọn loại bài tập (fill_blank hoặc multiple_choice)
4. **QuizPlayPage** → Chơi quiz (hiện tại: empty state với nút "Tạo bài tập mới")
5. **QuizResultPage** (TODO) → Xem kết quả sau khi hoàn thành

## API đã có sẵn

- **Topics API**: Đã được sử dụng trong `quiz_topic_selection_page.dart`
  - Provider: `topicsProvider` từ `lib/features/lesson/presentation/providers/topic_provider.dart`
  - Lấy danh sách topics theo level của user

## Widget tái sử dụng

- **TopicCard**: Widget hiển thị từng topic (đã có sẵn)
  - Path: `lib/features/lesson/presentation/widgets/topic_card.dart`
  - Sử dụng neumorphism design

## Tính năng đã hoàn thành ✅

- [x] **QuizTopicSelectionPage** - Chọn topic để luyện
- [x] **QuizTypeBottomSheet** - Chọn loại bài tập (fill_blank/multiple_choice)
- [x] **QuizPlayPage** - Màn chơi quiz với empty state
- [x] Routes và navigation hoàn chỉnh

## TODO cho tương lai

- [ ] **API Integration**: Lấy danh sách bài tập theo topic và type
- [ ] **Quiz Play**: Hiển thị câu hỏi khi có data
- [ ] Tạo widgets cho câu hỏi:
  - `fill_blank_question.dart` - Câu hỏi điền vào chỗ trống
  - `multiple_choice_question.dart` - Câu hỏi trắc nghiệm
- [ ] Tạo `quiz_result_page.dart` - Màn xem kết quả
- [ ] Tạo domain layer:
  - Entity: `question.dart`
  - Entity: `quiz_session.dart`
  - Entity: `quiz_result.dart`
- [ ] Tạo data layer và repositories
- [ ] Tính năng "Tạo bài tập mới"

## Theme & Design

Màn hình này tuân theo design system của app:
- Sử dụng `AppColors` và `AppSizes` constants
- Gradient header với màu xanh lá (#4CAF50)
- Neumorphism style cho topic cards
- CommonAppBar cho consistency

