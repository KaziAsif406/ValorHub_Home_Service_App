# Flutter Template

A modern, scalable Flutter application template following **Feature-Based Clean Architecture** with reactive programming patterns (MVVM-inspired).

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Technology Stack](#technology-stack)
- [Getting Started](#getting-started)
- [Installation](#installation)
- [Running the App](#running-the-app)
- [Project Features](#project-features)
- [Folder Structure Explanation](#folder-structure-explanation)
- [Best Practices](#best-practices)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

This is a production-ready Flutter template that demonstrates best practices in app architecture, state management, and code organization. It's designed to be scalable, testable, and maintainable for teams of any size.

### Key Features:
- ✅ **Feature-based organization** - Modular and scalable structure
- ✅ **Reactive programming** - RxDart for real-time data streams
- ✅ **Clean Architecture** - Clear separation of concerns
- ✅ **MVVM pattern** - Model-View-ViewModel for state management
- ✅ **Dependency Injection** - GetIt service locator pattern
- ✅ **Type-safe** - Strong typing throughout the codebase
- ✅ **Error handling** - Centralized error management
- ✅ **Responsive design** - FlutterScreenUtil for multi-device support

---

## 🏗️ Architecture

This project implements **Feature-Based Clean Architecture** - a layered architecture organized by features rather than by layer types.

### Architecture Layers

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│              (UI Screens & Widgets)                         │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                  REACTIVE LAYER (Rx)                        │
│              (State Management with RxDart)                 │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                    DATA LAYER                               │
│         (API Integration & Data Management)                 │
└──────────────────────┬──────────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                  NETWORK LAYER                              │
│           (HTTP Communication & Handling)                   │
└─────────────────────────────────────────────────────────────┘
```

### Why This Architecture?

| Benefit | Description |
|---------|-------------|
| **Modularity** | Each feature is independent and self-contained |
| **Scalability** | Easy to add new features without affecting existing code |
| **Testability** | Clear separation enables comprehensive unit testing |
| **Maintainability** | Changes isolated to specific features |
| **Team Collaboration** | Feature-based reduces merge conflicts |
| **Reactive** | Real-time data updates with RxDart streams |
| **Type Safety** | Strong typing prevents runtime errors |

For detailed architecture documentation, see [ARCHITECTURE_REPORT.md](./ARCHITECTURE_REPORT.md)

---

## 📂 Project Structure

```
flutter_template/
│
├── lib/
│   ├── main.dart                    # App entry point
│   ├── loading_screen.dart          # Initial loading screen
│   ├── navigation_screen.dart       # Navigation management
│   ├── welcome_screen.dart          # Welcome screen
│   │
│   ├── common_widgets/              # Reusable UI components
│   │   ├── custom_appbar.dart
│   │   ├── custom_button.dart
│   │   ├── custom_textform_field.dart
│   │   ├── loading_indicators.dart
│   │   └── ... (other shared widgets)
│   │
│   ├── constants/                   # App-wide constants
│   │   ├── app_constants.dart
│   │   ├── custome_theme.dart
│   │   ├── text_font_style.dart
│   │   └── validator.dart
│   │
│   ├── features/                    # Feature modules
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── rx_post_login/
│   │   │   │   └── rx_post_signup/
│   │   │   └── presentation/
│   │   │       ├── login.dart
│   │   │       └── signup.dart
│   │   │
│   │   ├── product/
│   │   │   ├── model/
│   │   │   ├── data/
│   │   │   │   ├── rx_get_products/
│   │   │   │   └── rx_get_product_details/
│   │   │   └── presentation/
│   │   │       ├── products.dart
│   │   │       └── product_details.dart
│   │   │
│   │   ├── home/
│   │   │   └── presentation/
│   │   │       └── home.dart
│   │   │
│   │   └── user_profile/
│   │       ├── data/
│   │       ├── model/
│   │       └── presentation/
│   │
│   ├── gen/                         # Generated assets
│   │   └── colors.gen.dart          # Auto-generated colors
│   │
│   ├── helpers/                     # Helper services
│   │   ├── all_routes.dart
│   │   ├── di.dart                  # Dependency Injection
│   │   ├── error_message_Handler.dart
│   │   ├── navigation_service.dart
│   │   └── ... (other helpers)
│   │
│   └── networks/                    # Network layer
│       ├── dio/
│       ├── endpoints.dart
│       └── exception_handler/
│
├── assets/
│   ├── color/
│   ├── fonts/
│   ├── icons/
│   ├── images/
│   └── lottie/
│
├── pubspec.yaml                     # Dependencies
├── analysis_options.yaml            # Lint rules
├── ARCHITECTURE_REPORT.md           # Detailed architecture docs
└── README.md                        # This file
```

### Feature Module Structure

Each feature follows this structure:

```
feature/
├── data/
│   ├── rx_get_*/
│   │   ├── api.dart          # API calls
│   │   └── rx.dart           # State management
│   └── models/
│       └── model.dart        # Data models
└── presentation/
    ├── pages/
    │   └── feature_screen.dart
    └── widgets/
        └── feature_widget.dart
```

---

## 🛠️ Technology Stack

| Technology | Version | Purpose |
|-----------|---------|---------|
| **Flutter** | Latest | UI Framework |
| **Dart** | 3.4.4+ | Programming Language |
| **RxDart** | ^0.28.0 | Reactive Streams |
| **Dio** | ^5.8.0 | HTTP Client |
| **GetIt** | ^8.0.3 | Service Locator (DI) |
| **GetStorage** | ^2.1.1 | Local Storage |
| **Lottie** | ^3.3.1 | Animations |
| **FlutterScreenUtil** | ^5.9.3 | Responsive Design |
| **CachedNetworkImage** | ^3.4.1 | Network Image Caching |
| **FlutterGen** | Latest | Asset Generation |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: >= 3.4.4
- Dart SDK: >= 3.4.4
- IDE: VS Code, Android Studio, or Xcode

### Installation

1. **Clone the repository:**
```bash
git clone https://github.com/NayemSoftvence/flutter_template.git
cd flutter_template
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Generate assets (colors, icons):**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Clean build:**
```bash
flutter clean
```

---

## 📱 Running the App

### Run on development environment:
```bash
flutter run
```

### Run with specific device:
```bash
flutter devices                    # List available devices
flutter run -d <device-id>         # Run on specific device
```

### Build for release (Android):
```bash
flutter build apk --release
# or for App Bundle
flutter build appbundle --release
```

### Build for release (iOS):
```bash
flutter build ios --release
```

---

## ✨ Project Features

### 1. Authentication (Feature: `auth`)
- Login screen with validation
- Signup screen with error handling
- Social authentication support (Facebook, Google)
- Password reset functionality

### 2. Product Management (Feature: `product`)
- Product listing with pagination
- Product details view
- Product search and filtering
- Image caching for performance

### 3. User Profile (Feature: `user_profile`)
- View user profile
- Edit profile information
- Local caching of profile data

### 4. Home Screen (Feature: `home`)
- Dashboard view
- Feature highlights
- Quick access to main features

### 5. Common Utilities
- **Custom Widgets** - Reusable UI components
- **Error Handling** - Centralized error management with toast notifications
- **Navigation** - Route management and deep linking support
- **Responsive Design** - Adapts to different screen sizes
- **Theming** - Customizable app theme and colors

---

## 📖 Folder Structure Explanation

### `common_widgets/`
Reusable UI components used across multiple features:
- `custom_appbar.dart` - Custom application bar
- `custom_button.dart` - Reusable button component
- `custom_textform_field.dart` - Form input field
- `loading_indicators.dart` - Loading animations
- `custom_toast.dart` - Toast notifications

### `constants/`
App-wide constants and configurations:
- `app_constants.dart` - Global constants
- `custome_theme.dart` - Theme and color palette
- `text_font_style.dart` - Typography styles
- `validator.dart` - Input validators

### `features/`
Modular features organized by domain:
- Each feature is **independent** and self-contained
- Contains all code needed for that feature (UI, state, API)
- Can be developed and tested separately

### `helpers/`
Utility services and functions:
- `di.dart` - Dependency Injection setup with GetIt
- `all_routes.dart` - Route definitions and navigation
- `error_message_Handler.dart` - Error handling and user feedback
- `navigation_service.dart` - Navigation management

### `networks/`
Network communication layer:
- `dio/` - Dio HTTP client configuration
- `endpoints.dart` - API endpoint definitions
- `exception_handler/` - Error mapping and handling

### `assets/`
Static resources:
- `color/` - Color definitions
- `fonts/` - Custom fonts
- `icons/` - App icons
- `images/` - Static images
- `lottie/` - Lottie animations

---

## ✅ Best Practices

### 1. **Single Responsibility Principle**
Each class has one reason to change:
```dart
// ✅ Good
class ProductApi { /* only API calls */ }
class ProductRx { /* only state management */ }
class ProductScreen { /* only UI */ }
```

### 2. **Feature-Based Organization**
All related code grouped together:
```
features/
├── product/           ← Complete feature
│   ├── data/
│   └── presentation/
└── auth/             ← Another complete feature
```

### 3. **Type Safety**
Use strong typing throughout:
```dart
// ✅ Good - Strong typing
Future<List<Product>> getProducts() { }

// ❌ Bad - Weak typing
Future<dynamic> getProducts() { }
```

### 4. **Error Handling**
Centralized error handling with user feedback:
```dart
try {
  // API call
} catch (error) {
  ErrorMessageHandler.showErrorToast(error);
}
```

### 5. **Reactive Programming**
Use RxDart streams for real-time updates:
```dart
// Observable stream
Stream<List<Product>> get products => dataFetcher.stream;

// UI observes the stream
StreamBuilder(
  stream: products,
  builder: (context, snapshot) { /* update UI */ }
)
```

### 6. **Dependency Injection**
Use GetIt for service locator pattern:
```dart
// Setup in di.dart
locator.registerSingleton<GetStorage>(GetStorage());

// Usage anywhere
final storage = locator.get<GetStorage>();
```

### 7. **Null Safety**
Leverage Dart null safety:
```dart
String? imageUrl;        // Can be null
String name;            // Cannot be null
required String id,     // Required parameter
```

### 8. **Consistent Naming**
Follow naming conventions:
- APIs: `GetProductsApi`, `LoginApi`
- Rx/ViewModel: `GetProductsRx`, `LoginRx`
- Screens: `ProductsScreen`, `LoginScreen`
- Models: `ProductModel`, `UserModel`

---

## 🧪 Testing

### Unit Testing
```bash
flutter test
```

### Widget Testing
```bash
flutter test test/widget_test.dart
```

### Test Coverage
```bash
flutter test --coverage
```

---

## 📊 Code Quality

### Run Analysis
```bash
flutter analyze
```

### Format Code
```bash
flutter format lib/
```

### Fix Code Issues
```bash
dart fix --apply
```

---

## 🤝 Contributing

1. **Create a feature branch:**
```bash
git checkout -b feature/your-feature-name
```

2. **Follow the feature structure:**
```
features/your_feature/
├── data/
│   ├── rx_get_*/
│   └── models/
└── presentation/
    ├── pages/
    └── widgets/
```

3. **Commit with meaningful messages:**
```bash
git commit -m "feat: add your feature description"
```

4. **Push and create a Pull Request:**
```bash
git push origin feature/your-feature-name
```

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable names
- Add comments for complex logic
- Keep functions small and focused

---

## 📝 Additional Documentation

For more detailed information about the architecture, design patterns, and best practices, see:
- [ARCHITECTURE_REPORT.md](./ARCHITECTURE_REPORT.md) - Comprehensive architecture documentation

---

## 🐛 Troubleshooting

### Build Issues
```bash
# Clean everything
flutter clean

# Get fresh dependencies
flutter pub get

# Regenerate assets
flutter pub run build_runner build --delete-conflicting-outputs
```

### Dependency Conflicts
```bash
# Update dependencies
flutter pub upgrade

# Get specific version
flutter pub get
```

### Device Issues
```bash
# List devices
flutter devices

# Specify device
flutter run -d <device-id>
```

---

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

---

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

---

## 👨‍💼 Author

**NayemSoftvence**

Repository: [flutter_template](https://github.com/NayemSoftvence/flutter_template)

---

## 🌟 Support

If you find this template helpful, please consider:
- ⭐ Starring the repository
- 🔗 Sharing it with the community
- 🐛 Reporting issues
- 💡 Contributing improvements

---

## 📞 Contact & Support

For questions, suggestions, or issues:
- Open an issue on GitHub
- Check existing documentation
- Review ARCHITECTURE_REPORT.md for detailed information

---

**Version:** 1.0.0  
**Last Updated:** November 14, 2025  
**Flutter Version:** 3.4.4+  
**Dart Version:** 3.4.4+
