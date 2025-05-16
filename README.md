# 📱 FairTasker

Streamline your daily operations with our task management app designed specifically for car rental businesses. Easily assign tasks to your team, track progress, and allow employees to complete or reschedule tasks as needed. Whether you're on Android, iOS, or web, stay organized and keep your support staff and drivers aligned—anytime, anywhere.

---

## 🧭 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Not Working / Pending](#not-working--pending)
- [Getting Started](#getting-started)
- [Command Line Cheatsheet](#command-line-cheatsheet)
- [Dependencies](#dependencies)
- [Folder Structure](#folder-structure)
- [License](#license)

---

## 📝 #Overview

- **Platform:** Flutter (iOS & Android)
- **State Management:** Bloc
- **Storage:** SharedPreferences
- **Backend:** REST API
- **Status:** 🚧✅ _Development && Production_

---

## ✅ Features

- [x] <Feature 1>
- [x] <Feature 2>
- [x] <Feature 3>

---

## ❌ Not Working / Pending

- [ ] <Feature or known issue 1>
- [ ] <Feature or known issue 2>

---

## 🚀 Getting Started

### 🔧 Prerequisites

- Flutter SDK (`>=3.2.0`)
- Dart SDK (`>=3.0.0`)
- IDE: Android Studio / VS Code

### ⬇️ Clone the Repository

```bash
git clone https://github.com/Guna-fairpay/FairTasker.git
cd FairTasker 
```
### 📦 Install Dependencies

```bash 
flutter pub get
```
### 🛠️ Code Generation (if applicable)
```bash
dart run build_runner build --delete-conflicting-outputs
```
### 📱 Run the App
```bash
flutter run
```
### To run on a specific device:
```bash
flutter run -d <device-id>
```
### 🧪 Command Line Cheatsheet
Command	Description
| Command                              | Description                  |
| ------------------------------------ | ---------------------------- |
| `flutter clean`                      | Clean build cache            |
| `flutter pub get`                    | Get packages                 |
| `flutter pub run build_runner build` | Run code generation          |
| `flutter doctor`                     | Check setup and dependencies |
| `flutter run -d <device_id>`         | Run on specific device       |
| `flutter test`                       | Run tests                    |
| `flutter upgrade`                    | Upgrade Flutter SDK          |

### 📁 Folder Structure (Example)
```bash
lib/
├── main.dart
├── core/             # Constants, themes, utilities
├── models/           # Data models
├── services/         # API or backend integration
├── providers/        # State management logic
├── screens/          # UI pages
├── widgets/          # Reusable widgets
├── routes/           # App navigation
```
### 📦 Dependencies
```bash
flutter_hooks


provider

http

hive

firebase_core

json_serializable
```

Update this list based on your pubspec.yaml.

### 📄 License
Distributed under the MIT License. See LICENSE for more information.

yaml

---

Let me know if you'd like a downloadable version or help converting this into a GitHub repository default readme.
