
## 🤝 Connect With Me

<p align="center">
  <a href="https://www.linkedin.com/in/ahmed-ekrem-hafiz/"><img width="40" src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linkedin/linkedin-original.svg" /></a>
  &nbsp;&nbsp;
  <a href="https://www.instagram.com/ahmedhafiz.33/"><img width="40" src="https://upload.wikimedia.org/wikipedia/commons/e/e7/Instagram_logo_2016.svg" /></a>
  &nbsp;&nbsp;
  <a href="mailto:ahmed@profscode.com"><img width="40" src="https://upload.wikimedia.org/wikipedia/commons/4/4e/Gmail_Icon.png" /></a>
  &nbsp;&nbsp;
  <a href="https://ahmedhafiz.com.tr/"><img width="40" src="https://cdn-icons-png.flaticon.com/512/841/841364.png" /></a>
</p>

---

# Profscode CRUD

A lightweight, **GetX-friendly HTTP CRUD helper** for Flutter & Dart.

Designed to be **fully user-controlled**:
no global singletons, no forced tokens, no hidden state.

Supports all common HTTP methods with **optional token refresh logic**, making it ideal for clean, scalable API layers.

---

## ✨ Features

* GET, POST, PUT, DELETE
* PATCH, HEAD, OPTIONS
* File & multipart upload support
* Optional **custom headers**
* Optional **automatic token refresh**
* No global state, fully injectable
* Simple, readable API surface
* Built on top of `http` + `GetX`

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  profscode_crud:
    git:
      url: https://github.com/Ahmedhafiz33/profscode_crud.git
      ref: main
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Usage

### 1️⃣ Basic Setup

```dart
import 'package:profscode_crud/profscode_crud.dart';

final crud = Crud(
  headersProvider: () => {
    'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
    'Content-Type': 'application/json',
  },
  onRefreshToken: () async {
    // Optional refresh token logic
    // Return true if refresh succeeds
    return false;
  },
);

final response = await crud.getRequest(
  'https://api.example.com/users',
);

print(response);
```

---

### 2️⃣ POST Request

```dart
final data = {
  'name': 'John',
  'email': 'john@example.com',
};

final response = await crud.postRequest(
  'https://api.example.com/users',
  data,
);

print(response);
```

---

### 3️⃣ PUT Request

```dart
final updateData = {'name': 'Jane'};

final response = await crud.putRequest(
  'https://api.example.com/users/1',
  updateData,
);

print(response);
```

---

### 4️⃣ PATCH Request

```dart
final response = await crud.patchRequest(
  'https://api.example.com/users/1',
  {'email': 'new@mail.com'},
);

print(response);
```

---

### 5️⃣ DELETE Request

```dart
final response = await crud.deleteRequest(
  'https://api.example.com/users/1',
);

print(response);
```

---

### 6️⃣ HEAD & OPTIONS

```dart
final head = await crud.headRequest(
  'https://api.example.com/users',
);

final options = await crud.optionsRequest(
  'https://api.example.com/users',
);
```

---

### 7️⃣ File Upload

```dart
final response = await crud.fileRequest(
  'https://api.example.com/upload',
  fields: {
    'user_id': '1',
  },
  files: [
    // http.MultipartFile instances
  ],
);

print(response);
```

---

## 🔐 Automatic Token Refresh

```dart
final crud = Crud(
  headersProvider: () => {
    'Authorization': 'Bearer $accessToken',
  },
  onRefreshToken: () async {
    final newToken = await fetchNewToken();
    if (newToken != null) {
      accessToken = newToken;
      return true;
    }
    return false;
  },
);
```

When the API returns **401 Unauthorized**,
`onRefreshToken` is called automatically and the request is retried once.

---

## ✅ Why Profscode CRUD?

* No hidden magic
* No forced architecture
* No global dependencies
* Works perfectly with **GetX**
* Easy to test, easy to extend
* Suitable for real production apps

---

## 🤝 Contributing

Contributions are welcome.

Ideas:

* Logging helpers
* Retry strategies
* Response wrappers
* Examples & tests

Feel free to open an issue or submit a pull request.

---

## 📄 License

MIT License
© Ahmed Ekrem Hafız

---