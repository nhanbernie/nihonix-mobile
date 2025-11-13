# Quiz Feature - Flow Diagram

## Visual Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                         PRACTICE PAGE                                │
│                                                                       │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐  ┌────────────┐   │
│  │Quiz nhanh  │  │ Nghe viết  │  │  Ghép câu  │  │ Viết Kanji │   │
│  └─────┬──────┘  └────────────┘  └────────────┘  └────────────┘   │
│        │                                                              │
└────────┼──────────────────────────────────────────────────────────────┘
         │ Click
         ▼
┌─────────────────────────────────────────────────────────────────────┐
│              QUIZ TOPIC SELECTION PAGE                               │
│                                                                       │
│  [Header: Quiz nhanh với icon và gradient xanh lá]                  │
│                                                                       │
│  ┌──────┐  ┌──────┐  ┌──────┐                                      │
│  │ 🏠  │  │ 🍜  │  │ 🎵  │  ... (Grid 3 cột)                      │
│  │Home │  │Food │  │Music│                                          │
│  └──┬───┘  └──┬───┘  └──┬───┘                                      │
│     │         │         │                                             │
└─────┼─────────┼─────────┼─────────────────────────────────────────────┘
      │ Click topic
      ▼
┌─────────────────────────────────────────────────────────────────────┐
│              QUIZ TYPE BOTTOM SHEET                                  │
│  ╔═══════════════════════════════════════════════════════════════╗ │
│  ║  Chọn loại bài tập                                            ║ │
│  ║  Chủ đề: Home                                                 ║ │
│  ║                                                                ║ │
│  ║  ┌────────────────────────────────────────────────────────┐  ║ │
│  ║  │ ✏️  Điền vào chỗ trống                                │  ║ │
│  ║  │     Hoàn thành câu bằng cách điền từ phù hợp          │  ║ │
│  ║  └──────────────────────────┬─────────────────────────────┘  ║ │
│  ║                             │                                  ║ │
│  ║  ┌────────────────────────────────────────────────────────┐  ║ │
│  ║  │ ✓  Trắc nghiệm                                        │  ║ │
│  ║  │     Chọn đáp án đúng từ nhiều lựa chọn                │  ║ │
│  ║  └──────────────────────────┬─────────────────────────────┘  ║ │
│  ╚════════════════════════════│══════════════════════════════════╝ │
└──────────────────────────────┼────────────────────────────────────┘
                               │ Select type
                               ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    QUIZ PLAY PAGE                                    │
│                   (Current: Empty State)                             │
│                                                                       │
│  [Header với màu theo type: fill_blank=purple, multiple_choice=green]│
│                                                                       │
│              ┌───────────────────────────┐                          │
│              │                           │                          │
│              │     📝                    │                          │
│              │                           │                          │
│              │  Chưa có bài tập          │                          │
│              │                           │                          │
│              │  Hiện tại chưa có bài     │                          │
│              │  tập cho chủ đề này.      │                          │
│              │  Bạn có thể tạo bài       │                          │
│              │  tập mới.                 │                          │
│              │                           │                          │
│              │  [➕ Tạo bài tập mới]     │  ← TODO: Create feature │
│              │                           │                          │
│              │  [  Quay lại  ]           │                          │
│              │                           │                          │
│              └───────────────────────────┘                          │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

## User Journey

### 1️⃣ Bước 1: Vào Practice
- User mở app → Nhấn tab "Practice" từ bottom nav
- Thấy 4 mode cards: Quiz nhanh, Nghe viết, Ghép câu, Viết Kanji
- **Action**: Nhấn vào "Quiz nhanh"

### 2️⃣ Bước 2: Chọn Topic
- Navigate đến `QuizTopicSelectionPage`
- Hiển thị grid 3 cột với các topics (API: `topicsProvider`)
- Topics được filter theo level của user
- **Action**: Nhấn vào topic bất kỳ (VD: "Home")

### 3️⃣ Bước 3: Chọn Loại Bài Tập
- Show `QuizTypeBottomSheet` (modal bottom sheet)
- 2 options:
  - 📝 **Điền vào chỗ trống** (fill_blank)
  - ✓ **Trắc nghiệm** (multiple_choice)
- **Action**: Chọn 1 trong 2 loại

### 4️⃣ Bước 4: Màn Chơi Quiz
- Navigate đến `QuizPlayPage` với params:
  - `topicId`: ID của topic
  - `topicName`: Tên topic để hiển thị
  - `type`: "fill_blank" hoặc "multiple_choice"
- **Current State**: Empty state với nút "Tạo bài tập mới"
- **Future**: Sẽ hiển thị danh sách câu hỏi từ API

## Technical Details

### Routes
```dart
'/practice'                    → PracticePage
'/practice/quiz/topics'        → QuizTopicSelectionPage
'/practice/quiz/play'          → QuizPlayPage
  ?topicId=xxx
  &topicName=yyy
  &type=fill_blank|multiple_choice
```

### Key Files
```
lib/features/practice/
├── presentation/
│   ├── pages/
│   │   ├── practice_page.dart
│   │   └── quiz/
│   │       ├── quiz_topic_selection_page.dart
│   │       └── quiz_play_page.dart
│   └── widgets/
│       ├── practice_mode_card.dart
│       └── quiz_type_bottom_sheet.dart
```

### Color Scheme
- **Quiz Topic Selection**: Green gradient (#4CAF50)
- **Fill Blank**: Purple (AppColors.accent2)
- **Multiple Choice**: Green (AppColors.accent1)

## Next Steps

1. ✅ **Done**: UI & Navigation complete
2. 🔄 **Next**: API integration để lấy exercises
3. 📝 **Future**: Implement question widgets
4. 🎯 **Future**: Quiz result page & scoring

