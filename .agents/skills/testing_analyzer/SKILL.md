---
name: Testing & Architecture Analyzer
description: A skill for running architecture analysis, writing widget tests, and maintaining code quality in this Flutter template project. Use this skill when generating tests, debugging test failures, or auditing project structure.
---

# 🧪 Testing & Architecture Analyzer Skill

This project has two testing/analysis tools: a **Dart CLI architecture analyzer** and a **widget test suite** using `flutter_test` + `mocktail`. Follow these rules strictly when writing or modifying tests.

---

## 🔍 1. Architecture Analyzer Script

**Location:** `tool/analyze_architecture.dart`

### How to Run
```bash
dart run tool/analyze_architecture.dart           # standard report
dart run tool/analyze_architecture.dart --verbose  # line-by-line details
```

### What It Checks (8 Categories)

| # | Category | Key Rules |
|---|----------|-----------|
| 1 | **Structure** | Every feature has `data/` + `presentation/`, rx_* naming, api.dart + rx.dart pairs |
| 2 | **API Layer** | Singleton pattern, Dio wrappers (`getHttp`/`postHttp`), `endpoints.dart` import, no hardcoded URLs |
| 3 | **Rx Layer** | Extends `RxResponseInt`, try/catch, `handleSuccessWithReturn`/`handleErrorWithReturn`, `ValueStream` |
| 4 | **Endpoints** | No URLs/API paths outside `endpoints.dart` |
| 5 | **Code Quality** | ScreenUtil `.h`/`.w`/`.r`/`.sp`, `AppColors` not `Colors.*`, `NavigationService` not `Navigator`, no provider/riverpod/bloc |
| 6 | **DI & Routes** | `api_access.dart` registrations, `all_routes.dart` import validity, orphaned features |
| 7 | **Common Widgets** | Flags duplicate widget implementations |
| 8 | **Pubspec** | Required deps: rxdart, dio, get_it, get_storage, flutter_screenutil, mocktail |

### Exit Codes
- `0` = all checks pass
- `1` = one or more failures detected

### Extending the Analyzer
To add a new check category:
1. Create a `void checkXxx(Directory libDir, String root)` function
2. Use `pass()`, `warn()`, `fail()` to record results
3. Call it from `main()` before `printReport()`

---

## 🧩 2. Widget Test Suite

**Location:** `test/`

### Project Test Structure
```
test/
├── helpers/
│   └── test_helpers.dart          # Reusable harness
├── common_widgets/
│   ├── custom_button_test.dart
│   └── custom_textform_field_test.dart
└── features/
    ├── auth/
    │   ├── login_test.dart
    │   └── signup_test.dart
    └── home/
        └── home_test.dart
```

### How to Run
```bash
flutter test                           # run all tests
flutter test test/features/auth/       # run specific feature tests
flutter test --coverage                # generate coverage report
```

---

## ⚙️ 3. Test Harness Rules (MANDATORY)

Every widget test **MUST** use the test harness from `test/helpers/test_helpers.dart`.

### Setup/Teardown Pattern
```dart
import '../../helpers/test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpTestDependencies();   // Stubs path_provider, inits GetStorage, resets GetIt
  });

  tearDownAll(() async {
    await tearDownTestDependencies(); // Resets GetIt
  });

  group('MyScreen', () {
    testWidgets('renders', (tester) async {
      await tester.pumpWidget(testableWidget(const MyScreen()));
      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
```

### Two Wrapper Functions

| Function | Use When |
|----------|----------|
| `testableWidget(child)` | Screen needs ScreenUtil `.h/.w/.r/.sp`, NavigationService, or RouteGenerator |
| `simpleTestableWidget(child)` | Simple widget with no ScreenUtil or routing deps (e.g., `CustomTextFormField`) |

---

## ⚠️ 4. Common Test Pitfalls

### `pumpAndSettle` Timeouts
**Never** use `pumpAndSettle()` when the widget contains an infinite animation (e.g., `CircularProgressIndicator`, Lottie loops). Use `pump()` instead:
```dart
// ❌ BAD — will timeout
await tester.pumpAndSettle();

// ✅ GOOD
await tester.pump();
```

### RichText / TextSpan Content
`find.text()` does **NOT** match text inside `TextSpan` (used by `CustomRichTextButton`). Use `find.byWidgetPredicate`:
```dart
final finder = find.byWidgetPredicate((widget) {
  if (widget is RichText) {
    return widget.text.toPlainText().contains('Sign Up');
  }
  return false;
});
expect(finder, findsOneWidget);
```

### Off-Screen Widgets in Scrollable Forms
Widgets below the fold (e.g., checkboxes at bottom of long forms) are off-screen in the 800×600 test viewport. Scroll first:
```dart
await tester.ensureVisible(find.byType(Checkbox));
await tester.pumpAndSettle();
await tester.tap(find.byType(Checkbox));
```

### GetStorage MissingPluginException
Always use `setUpTestDependencies()` from the harness — it stubs the `path_provider` platform channel before calling `GetStorage.init()`.

---

## 📝 5. Writing Tests for a New Feature

When a new feature is created at `lib/features/[name]/`, add tests at `test/features/[name]/`:

1. **Create test file** — `test/features/[name]/[screen_name]_test.dart`
2. **Import harness** — `import '../../helpers/test_helpers.dart';`
3. **Add setUpAll/tearDownAll** — call `setUpTestDependencies()` / `tearDownTestDependencies()`
4. **Wrap screen** — use `testableWidget(const MyScreen())`
5. **Test these minimum checks:**
   - Screen renders without errors (`find.byType(Scaffold)`)
   - Key UI text elements are present
   - Form fields exist and accept input (if applicable)
   - Buttons exist and are tappable
   - StreamBuilder-based screens: mock the Rx object's `BehaviorSubject` to test loading/data/error states

### Testing StreamBuilder Screens (Products, Profile, etc.)
For screens that consume Rx streams, inject test data via the `BehaviorSubject`:
```dart
import 'package:rxdart/rxdart.dart';
import 'package:template_flutter/networks/api_acess.dart';

// In test setup — push mock data into the stream
getProductsRxObj.dataFetcher.sink.add({'success': true, 'data': {...}});

// Then pump the widget and assert on rendered content
```
