# Profile Edit Feature Implementation

## 📋 Overview

Implemented complete **Edit Profile** feature following Clean Architecture pattern with:
- Update user profile (username, email, full_name, language)
- API integration with `PUT /api/users/{id}`
- Form validation
- Loading states
- Success/error handling
- Auth state synchronization

---

## 🏗️ Architecture

### **1. Domain Layer** (`lib/features/profile/domain/`)

#### **Entities:**
- `UpdateProfileRequest` - Domain entity for update request
  - `username?: String`
  - `email?: String`
  - `fullName?: String`
  - `language?: String`

#### **Repositories (Interface):**
- `ProfileRepository` - Abstract interface
  - `updateProfile(userId, request) -> User`

#### **Use Cases:**
- `UpdateProfileUseCase` - Business logic
  - Validates input (non-empty fields)
  - Delegates to repository
  - Returns updated `User` entity

---

### **2. Data Layer** (`lib/features/profile/data/`)

#### **Models:**
- `UpdateProfileRequestModel` - Data model with JSON serialization
  - `@JsonKey(name: 'full_name')` for API mapping
  - `fromDomain()` - Convert from domain entity
  - `toDomain()` - Convert to domain entity
  - `toJson()` - Serialize to JSON

- `UpdateProfileResponse` - Response wrapper
  - Parses API response structure:
    ```json
    {
      "success": true,
      "message": "Cập nhật thành công",
      "data": { user object },
      "errors": null,
      "statusCode": 200
    }
    ```

#### **DataSources:**
- `ProfileApi` (Retrofit) - API client
  - `@PUT('/users/{id}')` endpoint
  - Returns `dynamic` (raw response)

- `ProfileRemoteDataSource` - Wrapper
  - Calls `ProfileApi`
  - Parses response to `UpdateProfileResponse`
  - Handles errors with logging

#### **Repository Implementation:**
- `ProfileRepositoryImpl` implements `ProfileRepository`
  - Converts domain → data model
  - Calls remote data source
  - Converts data model → domain entity

---

### **3. Presentation Layer** (`lib/features/profile/presentation/`)

#### **Providers:**
- `profile_di.dart` - Dependency Injection
  - `profileRemoteDataSourceProvider`
  - `profileRepositoryProvider`
  - `updateProfileUseCaseProvider`

- `profile_provider.dart` - State Management
  - `ProfileState` (freezed):
    - `isLoading: bool`
    - `isSuccess: bool`
    - `error?: String`
  - `ProfileNotifier`:
    - `updateProfile()` - Calls use case, updates auth state
    - `reset()` - Reset state

#### **UI:**
- `ProfileEditPage` (ConsumerStatefulWidget)
  - Form with validation
  - Text fields: username, email, full name
  - Dropdown: language (vi, en, jp)
  - Loading button with spinner
  - Success/error snackbars
  - Auto-sync with auth state

---

## 🔄 Data Flow

```
UI (ProfileEditPage)
  ↓ user fills form & clicks "Lưu thay đổi"
ProfileNotifier.updateProfile()
  ↓ creates UpdateProfileRequest
UpdateProfileUseCase
  ↓ validates input
ProfileRepository (interface)
  ↓ implemented by
ProfileRepositoryImpl
  ↓ converts to UpdateProfileRequestModel
ProfileRemoteDataSource
  ↓ calls
ProfileApi (Retrofit)
  ↓ HTTP PUT /users/{id}
Backend API
  ↓ returns updated user
Parse UpdateProfileResponse
  ↓ convert to User entity
Update AuthProvider.user
  ↓ UI rebuilds
Show success message & pop
```

---

## 📡 API Integration

### **Endpoint:**
```
PUT /api/users/{id}
```

### **Request Body:**
```json
{
  "username": "nhan",
  "email": "nhanbernie@gmail.com",
  "full_name": "Tô Thiên Nhân",
  "language": "vi"
}
```

### **Response:**
```json
{
  "success": true,
  "message": "Cập nhật thành công",
  "data": {
    "id": "7153bddd-0ab6-47cb-b6ba-6114a20566cc",
    "username": "nhan",
    "email": "nhanbernie@gmail.com",
    "full_name": "Tô Thiên Nhân",
    "avatar_url": "https://...",
    "language": "vi",
    "status": "string",
    "role": "user",
    "level_code": "N5",
    "level": { ... },
    "created_at": "2025-11-06T09:41:03.378Z"
  },
  "errors": null,
  "statusCode": 200
}
```

---

## 🎨 UI Features

### **Header:**
- Orange gradient background
- Back button
- Title: "Sửa thông tin"
- Avatar display (80x80)

### **Form Fields:**
1. **Tên đăng nhập** (username)
   - Icon: `person_outline`
   - Validation: Required

2. **Email**
   - Icon: `email_outlined`
   - Validation: Required + contains '@'

3. **Họ và tên** (full_name)
   - Icon: `badge_outlined`
   - Validation: Required

4. **Ngôn ngữ** (language)
   - Icon: `language`
   - Dropdown: Tiếng Việt, English, 日本語

### **Save Button:**
- Full width, 50px height
- Orange background
- Shows spinner when loading
- Disabled during loading

### **Feedback:**
- Success: Green snackbar → pop to previous page
- Error: Red snackbar with error message

---

## 🔧 Auth State Sync

Added `updateUser()` method to `AuthNotifier`:

```dart
void updateUser(User updatedUser) {
  state = state.copyWith(user: updatedUser);
}
```

Called after successful profile update to sync user data across the app.

---

## ✅ Implementation Checklist

- [x] Domain layer (entities, repository interface, use case)
- [x] Data layer (models, API, data source, repository impl)
- [x] Presentation layer (providers, state management)
- [x] UI page with form validation
- [x] API integration (Retrofit)
- [x] Code generation (freezed, json_serializable, retrofit)
- [x] Auth state synchronization
- [x] Error handling
- [x] Loading states
- [x] Success/error feedback

---

## 🚀 Testing Flow

1. **Login** to the app
2. Navigate to **Profile** tab
3. Click **"Sửa thông tin"** button
4. Edit fields:
   - Username
   - Email
   - Full name
   - Language
5. Click **"Lưu thay đổi"**
6. Verify:
   - Loading spinner appears
   - Success message shows
   - Page pops back to profile
   - Profile page shows updated data
   - Auth state is synced

---

## 📝 Notes

- All fields are optional in the request (can update individually)
- Form validation ensures non-empty values before submission
- Language dropdown uses `initialValue` instead of deprecated `value`
- Avatar display uses network image with error fallback
- Clean Architecture ensures testability and maintainability

