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

- [ ] Current Location
- [ ] File / Image Picker

---

## ❌ Not Working / Pending

- [ ] Web Socket / Pusher
- [ ] Push Notification

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
### 🪐 Build Generation
```bash
fastforge release --name dev
```
### 🕹️ To run on a specific device:
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
├── main.dart # Initialize and Run the APP
├── firebase_options.dart # Firebase Default (Don't touch)
├── Bloc/             # Basic Blocs (🍂 Need to deprecate)
├── Component/           # Widget Components
├── core/         # API or backend integration
    └── app/
        └── build_flavor/
        └── config/
        └── extension/
        └── formatter/
        └── helper/
    └── initializer/
        └── common_initializer.dart # API Cache
        └── receive_intent.dart # Receive copied content 
        └── todo_support.dart # (🍂 Need to deprecate)
├── data/        # API Client
├── Event/          # Basic events
├── Remote/          # Downloder helper
├── Repository/           # Basic api repository
├── Response/           # APi Response
├── State/           # Basic States
├── UI/           # Screens
├── Utilities/           # Some helpers
```
### 📦 Dependencies
```bash
url_launcher: ^6.1.7

fl_chart: ^0.69.0

flutter_bloc: ^8.1.1

qr_flutter: ^4.0.0

equatable: ^2.0.5

dropdown_search: 5.0.6

smooth_page_indicator: ^1.2.0+3

image_picker: ^0.8.6+1

cached_network_image: ^3.2.3

connectivity_plus: ^4.0.2

http: ^1.2.1

fluttertoast: ^8.2.12

flutter_svg: ^2.0.17

nfc_manager: ^3.3.0

local_auth: ^2.1.7

shared_preferences: ^2.3.5

web_socket_channel: ^2.4.0

flutter_animation_progress_bar: ^2.3.1

flutter_slidable: ^3.1.2

date_time: ^0.12.0

collection: ^1.17.1

dio: ^5.7.0

talker_dio_logger: ^4.6.4

talker_http_logger: ^0.1.0-dev.30

http_interceptor: ^2.0.0

path_provider: ^2.1.5

permission_handler: ^11.3.1

data_table_2: ^2.0.0

fbroadcast: ^2.0.0

flutter_easyloading: ^3.0.5

dropdown_button2: ^2.3.9

flutter_video_thumbnail_plus: ^1.0.5

timeago: ^3.7.1

timezone: ^0.10.0

video_player: ^2.9.2

vsc_quill_delta_to_html: ^1.0.5

flutter_quill_delta_from_html: ^1.5.1

mime: ^2.0.0

file_picker: ^8.3.1

firebase_crashlytics: ^4.3.1

firebase_analytics: ^11.4.1

firebase_core: ^3.10.1

firebase_performance: ^0.10.1+1

flutter_typeahead: ^5.2.0

searchfield:
    git:
      url: https://github.com/PrabhuC-FP/searchfield.git
      ref: master

google_fonts: ^6.2.1

sticky_headers: ^0.3.0+2

number_pagination: ^1.1.6

geolocator: ^13.0.2

geocoding: ^3.0.0

open_file: ^3.5.10

timelines_plus: ^1.0.6

audioplayers: ^6.2.0

get_it: ^8.0.3

flutter_screenutil: ^5.9.3

logger: ^2.5.0

record: ^6.0.0

get_time_ago: ^2.3.0

html: ^0.15.5

package_info_plus: ^8.3.0

receive_sharing_intent:
    git:
      url: https://github.com/PrabhuC-FP/receive_sharing_intent
      ref: master

date_range_picker:
    git:
      url: https://github.com/PrabhuC-FP/date_range_picker
      ref: master

multi_dropdown:
    git:
      url: https://github.com/PrabhuC-FP/multiselect-dropdown
      ref: main

delightful_toast: ^1.1.0

flutter_map: ^8.1.1

latlong2: ^0.9.1

html_to_flutter: ^0.2.3-dev.8

html_to_flutter_table: ^0.0.2-dev.7

html_to_flutter_kit: ^0.0.3-dev.4

device_info_plus: ^11.4.0

segmented_button_slide: ^2.0.0

flutter_html: any

flutter_date_range_picker: any

flutter_quill: any

draggable_scrollbar: ^0.1.0

workmanager: ^0.6.0

r_icon_pro: ^1.0.3

iconsax: ^0.0.8

remixicon: ^1.4.1
```

### 📦 Dependency Overrides
```bash
intl: ^0.20.2
```

Update this list based on your pubspec.yaml.

### 📄 License
Distributed under the MIT License. See LICENSE for more information.

yaml

---