# Profscode CRUD

A lightweight, **GetX-based HTTP CRUD helper** for Flutter/Dart.
Completely **user-controlled**: no global tokens or headers are required.
Easily handles GET, POST, PUT, DELETE, Head, Patch, Options, File requests, with optional token refresh logic.

---

## Features

* GET, POST, PUT, DELETE, Head, Patch, Options, File requests
* Optional **custom headers**
* Optional **token refresh handling**
* Fully **injectable**, no global state
* Easy to extend for file/multi-file uploads

---

## Installation

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

## Usage

### 1️⃣ Basic Setup

```dart
import 'package:get/get.dart';
import 'package:profscode_crud/profscode_crud.dart';

void main() async {
  final crud = Crud(
    headersProvider: () => {
      'Authorization': 'Bearer YOUR_TOKEN',
      'Content-Type': 'application/json',
    },
    onRefreshToken: () async {
      // Optional: refresh token logic
      // return true if token refreshed successfully
      return false;
    },
  );

  final response = await crud.getRequest('https://api.example.com/users');
  print(response);
}
```

### 2️⃣ POST Request

```dart
final data = {'name': 'John', 'email': 'john@example.com'};
final response = await crud.postRequest('https://api.example.com/users', data);
print(response);
```

### 3️⃣ PUT Request

```dart
final updateData = {'name': 'Jane'};
final response = await crud.putRequest('https://api.example.com/users/1', updateData);
print(response);
```

---

### 4️⃣ DELETE Request

```dart
final response = await crud.deleteRequest('https://api.example.com/users/1');
print(response);
```

---

### Optional Token Refresh

```dart
final crud = Crud(
  headersProvider: () => {
    'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
  },
  onRefreshToken: () async {
    final newToken = await fetchNewToken(); // your refresh logic
    return newToken != null;
  },
);
```

✅ The `onRefreshToken` function will automatically be called when the API returns `401`.

---

## Advantages

* No dependency on global state
* Flexible headers per request
* Easy integration with any API
* Compatible with Flutter & Dart projects using GetX

---

## Contributing

Enhancements like **file upload support**, **multi-file requests**, or **logging** are welcome.
Submit issues or pull requests freely.

---

## License

MIT © Ahmed Ekrem Hafız

---
