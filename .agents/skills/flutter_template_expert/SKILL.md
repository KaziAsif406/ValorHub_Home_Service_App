---
name: Flutter Template Architect
description: A specialized skill for AI agents working within this specific Feature-Based Clean Architecture Flutter application. Use this skill whenever generating new features, debugging state logic, or referencing the project's offline documentation archive.
---

# 🚀 Flutter Template Architect — Complete Project Guide

> **Use this skill** whenever generating new features, modifying existing code,
> debugging state logic, writing tests, or reviewing PRs in this project.

This project follows a **Feature-Based Clean Architecture** built on:

| Layer | Tech | Purpose |
|-------|------|---------|
| State | **RxDart** (`BehaviorSubject`) | Sole reactive state management |
| Network | **Dio** (pre-configured wrappers) | HTTP client |
| DI | **GetIt** | Global singletons |
| Storage | **GetStorage** | Local key-value persistence |
| Scaling | **flutter_screenutil** | Responsive layout scaling |
| Colors | **FlutterGen** (`AppColors`) | Centralized color constants |
| Navigation | **NavigationService** | Global navigator key routing |

---

## 🏗️ 1. Project Architecture

### 1.1 Directory Blueprint

```
lib/
├── common_widgets/          # Shared UI components (CustomButton, CustomTextFormField, etc.)
├── constants/               # App constants, text styles, themes
│   ├── app_constants.dart   # Regex validators, storage keys
│   ├── custome_theme.dart   # Material theme config
│   └── text_font_style.dart # Pre-defined TextStyles with ScreenUtil
├── features/                # Feature modules (see below)
├── gen/
│   └── colors.gen.dart      # Auto-generated AppColors from assets/color/colors.xml
├── helpers/
│   ├── all_routes.dart      # Route constants + RouteGenerator
│   ├── di.dart              # GetIt registration
│   ├── navigation_service.dart  # Global navigator
│   ├── ui_helpers.dart      # UIHelper spacing utilities
│   ├── helper_methods.dart  # Misc utilities
│   ├── loading_helper.dart  # Future.loader extension
│   └── error_message_handler.dart
├── networks/
│   ├── api_acess.dart       # Global Rx object instances
│   ├── rx_base.dart         # RxResponseInt abstract base class
│   ├── endpoints.dart       # All API URL strings
│   └── dio/
│       └── dio.dart         # Pre-configured Dio wrappers (getHttp, postHttp, etc.)
├── main.dart
└── loading_screen.dart
```

### 1.2 Feature Module Structure

Every feature MUST follow this exact structure:

```
lib/features/[feature_name]/
├── data/
│   ├── rx_[verb]_[subject]/    # E.g., rx_get_products, rx_post_login
│   │   ├── api.dart            # Singleton API class — HTTP only
│   │   └── rx.dart             # RxDart controller — stream management
│   └── model/                  # (or models/) — Response model classes
│       └── [feature]_model.dart
└── presentation/
    ├── [feature_name].dart     # Main screen widget
    └── widget/                 # Sub-components for this screen
        └── [widget_name].dart
```

**Key rules:**
- The `data/` directory is optional — simple UI-only features (e.g., `home`) may omit it.
- Each `rx_*` folder must contain both `api.dart` AND `rx.dart`.
- Folder names use `rx_[verb]_[subject]` pattern: `rx_get_products`, `rx_post_login`.

---

## 🔌 2. API Integration Workflow

When adding a new API endpoint, follow these 5 steps **in order**:

### Step 1: Define the Endpoint

Add the URL in `lib/networks/endpoints.dart`:

```dart
// In the Endpoints class:
static String users() => "/api/users";
static String userById(int id) => "/api/users/$id";
```

### Step 2: Create the API Class

File: `lib/features/[feature]/data/rx_[action]/api.dart`

```dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/dio/dio_exceptions.dart';

class GetUsersApi {
  static final GetUsersApi _singleton = GetUsersApi._internal();
  GetUsersApi._internal();
  static GetUsersApi get instance => _singleton;

  Future<Map> getUsersData() async {
    Response response = await getHttp(Endpoints.users());
    if (response.statusCode == 200) {
      return json.decode(json.encode(response.data));
    } else {
      throw DataSource.DEFAULT.getFailure();
    }
  }
}
```

**Mandatory patterns:**
- ✅ Singleton: `_singleton`, `_internal()`, `get instance`
- ✅ Use `getHttp`/`postHttp`/`putHttp`/`deleteHttp` wrappers
- ✅ Import and use `Endpoints.*` — **NEVER** hardcode URLs
- ✅ Reference `DataSource` for error handling

### Step 3: Create the Rx Controller

File: `lib/features/[feature]/data/rx_[action]/rx.dart`

```dart
import 'package:rxdart/rxdart.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

class GetUsersRx extends RxResponseInt {
  final api = GetUsersApi.instance;

  GetUsersRx({required super.empty, required super.dataFetcher});

  Future<bool> fetchUsers() async {
    try {
      Map data = await api.getUsersData();
      return await handleSuccessWithReturn(data);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  ValueStream get fileData => dataFetcher.stream;
}
```

**Mandatory patterns:**
- ✅ Extends `RxResponseInt`
- ✅ `try/catch` with `handleSuccessWithReturn` / `handleErrorWithReturn`
- ✅ Exposes `ValueStream get fileData => dataFetcher.stream`
- ✅ References `*Api.instance`

### Step 4: Register the Rx Object

File: `lib/networks/api_acess.dart`

```dart
import 'package:rxdart/rxdart.dart';
import '../features/[feature]/data/rx_[action]/rx.dart';

GetUsersRx getUsersRxObj =
    GetUsersRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
```

### Step 5: Consume in UI

File: `lib/features/[feature]/presentation/[screen].dart`

```dart
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  @override
  void initState() {
    super.initState();
    getUsersRxObj.fetchUsers();  // Trigger API call
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: getUsersRxObj.fileData,
        builder: (context, snapshot) {
          if (snapshot.data == getUsersRxObj.empty) {
            return const WaitingWidget();
          }
          if (snapshot.hasData && snapshot.data != null) {
            return _buildContent(snapshot.data!);
          } else if (snapshot.hasError) {
            return const NotFoundWidget();
          }
          return const WaitingWidget();
        },
      ),
    );
  }
}
```

### Step 6: Register Route (if navigable)

File: `lib/helpers/all_routes.dart`

```dart
// 1. Add route constant
static const String usersScreen = '/UsersScreen';

// 2. Add case in RouteGenerator.generateRoute()
case Routes.usersScreen:
  return defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoPageRoute(builder: (context) => const UsersScreen())
      : _FadedTransitionRoute(
          widget: const UsersScreen(), settings: settings);
```

---

## 🛡️ 3. Code Quality Rules (Enforced by Analyzer)

Run the architeture analyzer with: `dart run tool/analyze_architecture.dart`

### 3.1 ScreenUtil — MANDATORY

**Every** layout dimension in presentation files must use ScreenUtil extensions:

| Property | Extension | Example |
|----------|-----------|---------|
| Height, vertical | `.h` | `height: 60.h` |
| Width, horizontal | `.w` | `width: 200.w`, `EdgeInsets.all(16.w)` |
| Border radius | `.r` | `BorderRadius.circular(12.r)` |
| Font size, icon size | `.sp` | `fontSize: 14.sp`, `size: 24.sp` |

**Exceptions** (raw numbers OK):
- Line-height multiplier: `height: 1.5` inside `.copyWith()`
- `childAspectRatio`, `crossAxisCount`, `flex`, `Offset`, `opacity`, `alpha`

❌ `height: 120` → ✅ `height: 120.h`
❌ `SizedBox(width: 20)` → ✅ `SizedBox(width: 20.w)`
❌ `EdgeInsets.all(16)` → ✅ `EdgeInsets.all(16.w)`

### 3.2 Colors — Use AppColors

Always use `AppColors` from `lib/gen/colors.gen.dart`.

**Allowed exceptions:**
- `Colors.transparent` ✅
- `Colors.black` ✅
- `Colors.white` ✅

❌ `Colors.green` → ✅ `AppColors.c4CAF50`
❌ `Colors.red` → ✅ `AppColors.cF44336`

**Adding new colors / assets / fonts — FlutterGen:**

This project uses **FlutterGen** to generate type-safe references for colors, assets, and fonts.

```bash
# Regenerate after changing colors.xml, adding assets, or updating fonts:
fluttergen -c pubspec.yaml
```

| Resource | Source file | Generated output |
|----------|-----------|-----------------|
| Colors | `assets/color/colors.xml` | `lib/gen/colors.gen.dart` (`AppColors`) |
| Assets | `assets/` directories | `lib/gen/assets.gen.dart` |
| Fonts | `pubspec.yaml` font declarations | `lib/gen/fonts.gen.dart` |

**Workflow:**
1. Add hex color to `assets/color/colors.xml`
2. Run `fluttergen -c pubspec.yaml`
3. Use the new `AppColors.cXXXXXX` constant in your code

### 3.3 Navigation — Use NavigationService

**NEVER** use `Navigator.of(context)`, `Navigator.push()`, or `Navigator.pop()`.

```dart
// ✅ Correct
NavigationService.navigateTo(Routes.usersScreen);
NavigationService.navigateToWithArgs(Routes.details, {'id': 42});
NavigationService.goBack;
NavigationService.navigateToReplacement(Routes.home);
NavigationService.navigateToUntilReplacement(Routes.login);

// ❌ Wrong
Navigator.of(context).pushNamed('/users');
Navigator.push(context, MaterialPageRoute(...));
```

### 3.4 State Management — RxDart ONLY

**FORBIDDEN:** `provider`, `riverpod`, `flutter_bloc`, `mobx`, `getx`

- Never import `package:provider`, `package:riverpod`, or `package:flutter_bloc`
- Stream flow is always: **API → Rx Controller → StreamBuilder in UI**
- Use `BehaviorSubject` for all reactive streams

### 3.5 Code Style

| Rule | Detail |
|------|--------|
| No `print()` | Use `dart:developer` `log()` instead |
| No `var` in data layer | Use explicit types in `api.dart` and `rx.dart` |
| Reuse common widgets | Use `CustomButton`, `CustomTextFormField`, `WaitingWidget`, etc. |
| No hardcoded URLs | All API URLs go in `Endpoints` class |
| Explicit types | Prefer `final String name` over `var name` |
| Null safety | Use `?`, `!`, `??` properly; never force-unwrap without guard |

---

## 📁 4. Key Files Reference

### `lib/networks/rx_base.dart` — Base Class for All Rx Controllers

```dart
abstract class RxResponseInt<T> {
  T empty;
  BehaviorSubject<T> dataFetcher;

  RxResponseInt({required this.empty, required this.dataFetcher});

  dynamic handleSuccessWithReturn(T data) {
    dataFetcher.sink.add(data);
    return data;
  }

  dynamic handleErrorWithReturn(dynamic error) {
    log(error.toString());
    dataFetcher.sink.addError(error);
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }

  void clean() => dataFetcher.sink.add(empty);
  void dispose() => dataFetcher.close();
}
```

### `lib/helpers/di.dart` — Dependency Injection

```dart
final locator = GetIt.instance;
final appData = locator.get<GetStorage>();

void diSetup() {
  locator.registerSingleton<GetStorage>(GetStorage());
}
```

### `lib/helpers/navigation_service.dart` — Available Methods

| Method | Description |
|--------|-------------|
| `navigateTo(route)` | Push named route |
| `navigateToReplacement(route)` | Replace current with named route |
| `navigateToUntilReplacement(route)` | Clear stack, push route |
| `navigateToWithArgs(route, map)` | Push with `Map` arguments |
| `navigateToWithObject(route, obj)` | Push with object argument |
| `popAndReplace(route)` | Pop current, push route |
| `goBack` | Pop current route |
| `goBeBack` | Check if can pop |
| `context` | Get current `BuildContext` |

### `lib/helpers/ui_helpers.dart` — Spacing Utilities

```dart
UIHelper.verticalSpace(8.h)      // Custom vertical gap
UIHelper.horizontalSpace(12.w)   // Custom horizontal gap
UIHelper.verticalSpaceSmall       // 10.w preset
UIHelper.verticalSpaceMedium      // 20.w preset
UIHelper.kDefaulutPadding()       // 20.sp default padding
```

### `lib/constants/app_constants.dart` — Validators & Keys

Contains regex patterns for email/phone validation and `GetStorage` keys:
- `regExpEmail` — Email validation
- `regexpPhone` — Phone validation
- `isLogIn`, `userId` — Storage keys

---

## � 5. Testing Guidelines

All tests use `mocktail` for mocking. Run: `flutter test`

### 5.1 Test Setup (MANDATORY)

Every widget test must call the shared test harness:

```dart
import '../helpers/test_helpers.dart';

void main() {
  setUp(() async {
    await setUpTestDependencies();  // Inits GetStorage, stubs path_provider
  });

  testWidgets('test description', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (_, __) => const YourScreen(),
        ),
      ),
    );
    await tester.pump();  // Use pump(), NOT pumpAndSettle()
  });
}
```

### 5.2 Common Testing Pitfalls

| Problem | Solution |
|---------|----------|
| `pumpAndSettle()` timeout | Use `pump()` — animations like `CircularProgressIndicator` never settle |
| `find.text()` fails for RichText | Use `find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().contains('...'))` |
| Off-screen widget tap fails | Call `await tester.ensureVisible(finder)` before tapping |
| `GetStorage` crashes | Call `setUpTestDependencies()` in `setUp()` |
| `MissingPluginException` | The test helper stubs `path_provider` channel automatically |

---

## 🧹 6. Starting a New Project (Template Cleanup)

If using this template for a new project:

1. **Delete sample features**: `auth/`, `product/`, `home/`, `user_profile/`
2. **Remove their routes** from `lib/helpers/all_routes.dart`
3. **Remove their Rx objects** from `lib/networks/api_acess.dart`
4. **Keep `example/`** as an architectural blueprint (it's safely commented out)
5. **Update identifiers**: `applicationId` (Android), `bundleId` (iOS), package name in `pubspec.yaml`
6. **Update `endpoints.dart`** with your API base URL
7. **Run `dart run tool/analyze_architecture.dart`** to verify clean state

---

## 🔧 7. Architecture Analyzer

This project includes a custom static analysis tool: `tool/analyze_architecture.dart`

```bash
# Standard run
dart run tool/analyze_architecture.dart

# Verbose (shows individual violations)
dart run tool/analyze_architecture.dart --verbose
```

**What it checks (8 categories):**

| Category | Checks |
|----------|--------|
| Structure | Feature directories, `rx_*` folders, `api.dart` + `rx.dart` pairs |
| API Layer | Singleton pattern, Dio wrappers, endpoint imports, no hardcoded URLs |
| Rx Layer | `extends RxResponseInt`, try/catch, handle methods, ValueStream |
| Endpoints | Centralized URLs, no scattered path literals |
| Code Quality | ScreenUtil compliance, AppColors, NavigationService, no forbidden packages |
| DI & Routes | api_access.dart registration, route imports, orphaned features |
| Common Widgets | Widget reuse, no duplicated custom widgets |
| Pubspec | Required dependencies present |

**Score interpretation:**
- 🎉 **PERFECT** — All checks pass, 0 warnings, 0 failures
- ⚡ **Good shape** — 0 failures, some warnings
- 🚨 **Fix before shipping** — Has failures

---

## ⚠️ 8. Strict Rules Checklist

Before committing any code, verify:

- [ ] Feature follows `features/[name]/data/rx_*/` + `presentation/` structure
- [ ] API class uses singleton pattern with Dio wrappers
- [ ] Rx class extends `RxResponseInt` with try/catch
- [ ] Rx object registered in `api_acess.dart`
- [ ] All layout values use `.h`, `.w`, `.sp`, `.r` extensions
- [ ] Colors use `AppColors.*`, not `Colors.*` (except transparent/black/white)
- [ ] Navigation uses `NavigationService`, not `Navigator`
- [ ] No `provider`, `riverpod`, or `flutter_bloc` imports
- [ ] No `print()` — use `log()` from `dart:developer`
- [ ] No hardcoded API URLs — everything through `Endpoints`
- [ ] Route registered in `all_routes.dart` (if screen is navigable)
- [ ] Tests use `setUpTestDependencies()` and `pump()` (not `pumpAndSettle()`)
- [ ] `dart run tool/analyze_architecture.dart` passes with 0 failures

---

## 📚 9. Offline Documentation

Flutter 3.41.1 docs are available locally at `flutter_doc/` directory.
Use `view_file` or `grep_search` against these files when you need to check a Flutter API without web searching.
