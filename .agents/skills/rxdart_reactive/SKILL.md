---
name: RxDart Reactive Programming
description: A skill for working with RxDart-based reactive state management in this Flutter template. Use this skill when creating, debugging, or extending Rx controllers, API integrations, and stream-based UI patterns.
---

# 🔄 RxDart Reactive Programming Skill

This project uses **RxDart** (`rxdart: ^0.28.0`) as its **sole state management solution**. There is **NO** Provider, Riverpod, Bloc, or MobX. All reactive state flows through RxDart `BehaviorSubject` streams, following an **API → Rx → UI** pipeline.

> **Official Docs:** [pub.dev/packages/rxdart](https://pub.dev/packages/rxdart) | [API Reference](https://pub.dev/documentation/rxdart/latest/rx/rx-library.html)

---

## 🏗️ 1. Architecture: Why RxDart Instead of Provider/Riverpod

| Concern | How RxDart Handles It |
|---------|----------------------|
| **State storage** | `BehaviorSubject<T>` — caches last value, replays to new listeners |
| **State updates** | `.sink.add(data)` pushes new state |
| **UI reactivity** | `StreamBuilder(stream: rxObj.fileData)` rebuilds on new events |
| **Error handling** | `.sink.addError(err)` + centralized `ErrorMessageHandler` |
| **Dependency injection** | Global Rx objects in `api_acess.dart` — no `ChangeNotifier`, no `StateNotifier` |
| **Stream composition** | RxDart operators: `debounceTime`, `switchMap`, `combineLatest`, etc. |

**This architecture is intentional.** RxDart gives fine-grained control over async data flows without the boilerplate of Provider/Riverpod. Do NOT introduce any other state management library.

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   API Layer  │────▶│   Rx Layer   │────▶│   UI Layer   │
│  (api.dart)  │     │  (rx.dart)   │     │ (screen.dart)│
│              │     │              │     │              │
│  Singleton   │     │  Extends     │     │ StreamBuilder │
│  Dio HTTP    │     │  RxResponseInt│    │  snapshot.data│
│  Endpoints.* │     │  BehaviorSubj│     │  snapshot.err │
└──────────────┘     └──────────────┘     └──────────────┘
```

---

## 📦 2. Core: `BehaviorSubject<T>` (Official API)

> **Source:** [BehaviorSubject class](https://pub.dev/documentation/rxdart/latest/rx/BehaviorSubject-class.html)

A special `StreamController` that:
- **Caches the latest item** added to the controller
- **Emits that cached item** as the first event to any new listener
- Is a **broadcast (hot) controller** — multiple listeners allowed
- Optionally accepts a **seed value** emitted if no items have been added yet

```dart
// Without seed — starts empty
final subject = BehaviorSubject<int>();
subject.add(1);
subject.add(2);
subject.add(3);
subject.stream.listen(print); // prints 3 (latest cached value)

// With seed — starts with initial value
final seeded = BehaviorSubject<int>.seeded(0);
seeded.stream.listen(print); // prints 0 immediately
```

### Key Properties

| Property | Type | Description |
|----------|------|-------------|
| `value` | `T` | Synchronously read the last emitted value |
| `valueOrNull` | `T?` | Same as `value` but nullable if no value emitted |
| `hasValue` | `bool` | `true` if at least one value has been emitted |
| `hasError` | `bool` | `true` if the last event was an error |
| `error` | `Object` | The last emitted error |
| `errorOrNull` | `Object?` | The last error or null |
| `stream` | `ValueStream<T>` | The observable stream |
| `sink` | `StreamSink<T>` | Add data/errors to the subject |
| `isClosed` | `bool` | Whether `close()` has been called |
| `hasListener` | `bool` | Whether any listener is subscribed |

### Key Methods

| Method | Description |
|--------|-------------|
| `add(T value)` | Push a new value to all listeners |
| `addError(Object error)` | Push an error to all listeners |
| `close()` | Close the subject permanently |
| `listen(onData, {onError, onDone})` | Subscribe to the stream |

---

## 🧬 3. Base Class: `RxResponseInt<T>` (Project-Specific)

**Location:** `lib/networks/rx_base.dart`

Every Rx controller in this project extends this abstract class:

```dart
abstract class RxResponseInt<T> {
  T empty;                        // Reset value (usually {})
  BehaviorSubject<T> dataFetcher; // The core reactive stream

  RxResponseInt({required this.empty, required this.dataFetcher});

  dynamic handleSuccessWithReturn(T data) {
    dataFetcher.sink.add(data);   // Push data to UI
    return data;
  }

  dynamic handleErrorWithReturn(dynamic error) {
    log(error.toString());
    dataFetcher.sink.addError(error);
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }

  void clean() => dataFetcher.sink.add(empty);  // Reset stream
  void dispose() => dataFetcher.close();         // Close permanently
}
```

### Override Pattern
Rx controllers **override** `handleSuccessWithReturn` / `handleErrorWithReturn` to customize behavior:

```dart
@override
handleSuccessWithReturn(data) async {
  // Custom: save auth token, navigate, etc.
  String? token = data['data']['token'];
  DioSingleton.instance.update(token!);
  await appData.write(kKeyAccessToken, token);
  dataFetcher.sink.add(data);  // Always push to stream
  return true;
}
```

---

## 🔌 4. Creating a GET Rx Controller (Complete Template)

### Step 1: Endpoint (`lib/networks/endpoints.dart`)
```dart
static String users() => "/users";
```

### Step 2: API Class (`data/rx_get_users/api.dart`)
```dart
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/exception_handler/data_source.dart';

final class GetUsersApi {
  static final GetUsersApi _singleton = GetUsersApi._internal();
  GetUsersApi._internal();
  static GetUsersApi get instance => _singleton;

  Future<Map> getUsersData() async {
    try {
      Response response = await getHttp(Endpoints.users());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(json.encode(response.data));
      } else {
        throw DataSource.DEFAULT.getFailure();
      }
    } catch (error) {
      rethrow;  // Let Rx layer handle errors
    }
  }
}
```

### Step 3: Rx Controller (`data/rx_get_users/rx.dart`)
```dart
import 'package:rxdart/rxdart.dart';
import '../../../../helpers/error_message_handler.dart';
import '../../../../networks/rx_base.dart';
import 'api.dart';

final class GetUsersRx extends RxResponseInt {
  final api = GetUsersApi.instance;
  GetUsersRx({required super.empty, required super.dataFetcher});

  ValueStream get fileData => dataFetcher.stream;

  Future<bool> fetchUsers() async {
    try {
      Map data = await api.getUsersData();
      return await handleSuccessWithReturn(data);
    } catch (error) {
      return await handleErrorWithReturn(error);
    }
  }

  @override
  handleSuccessWithReturn(data) async {
    dataFetcher.sink.add(data);
    return true;
  }

  @override
  handleErrorWithReturn(error) {
    ErrorMessageHandler.showErrorToast(error);
    return false;
  }
}
```

### Step 4: Register (`lib/networks/api_acess.dart`)
```dart
GetUsersRx getUsersRxObj =
    GetUsersRx(empty: {}, dataFetcher: BehaviorSubject<Map>());
```

### Step 5: UI (`presentation/users_screen.dart`)
```dart
StreamBuilder(
  stream: getUsersRxObj.fileData,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const WaitingWidget();
    } else if (snapshot.hasData && snapshot.data != null) {
      return buildContent(snapshot.data!);
    } else {
      return const NotFoundWidget();
    }
  },
)
```

---

## 📤 5. POST Rx Controller with Auth Token

POST controllers follow the same pattern but handle auth persistence:

```dart
Future<bool> postLogin({required String email, required String password}) async {
  try {
    Map<String, dynamic> data = {"email": email, "password": password};
    Map resdata = await api.postLogIn(data);
    return await handleSuccessWithReturn(resdata);  // overridden below
  } catch (error) {
    return await handleErrorWithReturn(error);
  }
}

@override
handleSuccessWithReturn(data) async {
  String? token = data['data']['token'];
  int id = data['data']['user']['id'];
  DioSingleton.instance.update(token!);
  await appData.write(kKeyIsLoggedIn, true);
  await appData.write(kKeyUserID, id);
  await appData.write(kKeyAccessToken, token);
  dataFetcher.sink.add(data);
  performPostLoginActions();
  return true;
}
```

---

## 🛠️ 6. RxDart Operators Reference (Use Instead of Provider Logic)

> **Full list:** [pub.dev/packages/rxdart#extension-methods](https://pub.dev/packages/rxdart#extension-methods)

### Commonly Useful Operators

| Operator | What It Does | Use Case |
|----------|-------------|----------|
| `debounceTime(Duration)` | Waits for a pause in events before emitting | Search-as-you-type input |
| `throttleTime(Duration)` | Limits emission rate | Scroll events, button spam |
| `switchMap(fn)` | Cancels previous inner stream on new event | API calls that replace previous |
| `distinctUnique()` | Filters out duplicate consecutive values | Avoid redundant rebuilds |
| `startWith(value)` | Prepends a value before stream events | Default/loading state |
| `scan(accumulator, seed)` | Reduces stream to accumulated value | Running totals, pagination |
| `combineLatest` | Combines latest values from multiple streams | Dashboard with multiple data sources |
| `mergeWith([streams])` | Merges multiple streams into one | Multiple event sources |
| `doOnData(fn)` | Side-effect on each data event | Logging, analytics |
| `doOnError(fn)` | Side-effect on each error | Error tracking |
| `onErrorReturn(value)` | Replace errors with a fallback value | Graceful degradation |
| `onErrorResumeNext(stream)` | Switch to fallback stream on error | Retry with different source |
| `whereNotNull()` | Filters out null values | Clean data pipeline |
| `delay(Duration)` | Delays each event | Artificial loading states |

### Example: Search with Debounce
```dart
final searchSubject = BehaviorSubject<String>.seeded('');

// In initState or constructor:
searchSubject.stream
    .debounceTime(const Duration(milliseconds: 300))
    .where((query) => query.length >= 2)
    .distinct()  // skip if same query
    .switchMap((query) => Stream.fromFuture(api.search(query)))
    .listen((results) {
      searchResultsSubject.add(results);
    });

// In UI — push text changes to subject:
onChanged: (text) => searchSubject.add(text),
```

### Example: Combining Streams
```dart
// Dashboard screen needs products AND profile data
Rx.combineLatest2(
  getProductsRxObj.fileData,
  profileRxObj.fileData,
  (products, profile) => {'products': products, 'profile': profile},
).listen((combined) {
  dashboardSubject.add(combined);
});
```

---

## 🔢 7. RxDart Stream Classes Reference

> **Source:** [pub.dev/packages/rxdart#stream-classes](https://pub.dev/packages/rxdart#stream-classes)

| Class | Factory | Description |
|-------|---------|-------------|
| `CombineLatestStream` | `Rx.combineLatest2..9` | Combine latest values from 2-9 streams |
| `MergeStream` | `Rx.merge` | Merge multiple streams into one |
| `ConcatStream` | `Rx.concat` | Emit events from streams sequentially |
| `ForkJoinStream` | `Rx.forkJoin2..9` | Wait for all streams to complete, emit last values |
| `RetryStream` | `Rx.retry` | Retry a failing stream N times |
| `RetryWhenStream` | `Rx.retryWhen` | Retry with custom logic |
| `SwitchLatestStream` | `Rx.switchLatest` | Switch to latest inner stream |
| `RaceStream` | `Rx.race` | Emit only from the first stream to emit |
| `TimerStream` | `Rx.timer` | Emit a value after a delay |
| `DeferStream` | `Rx.defer` | Create stream lazily on subscription |

---

## 🧩 8. Subjects (Official API)

> **Source:** [pub.dev/packages/rxdart#subjects](https://pub.dev/packages/rxdart#subjects)

| Subject | Description | This Project Uses |
|---------|-------------|-------------------|
| **`BehaviorSubject`** | Caches latest value, replays to new listeners | ✅ **Primary** |
| **`ReplaySubject`** | Caches ALL values, replays full history | ❌ Not used (available if needed) |

**Why BehaviorSubject?** The UI only needs the latest state. `ReplaySubject` would replay the entire history, causing unnecessary rebuilds.

### BehaviorSubject vs Dart StreamController

| Feature | `StreamController` | `BehaviorSubject` |
|---------|-------------------|-------------------|
| Replays last value to new listeners | ❌ No | ✅ Yes |
| Synchronous `.value` access | ❌ No | ✅ Yes |
| Broadcast by default | ❌ No (single-sub) | ✅ Yes |
| RxDart operators | ❌ No | ✅ Yes |

---

## ⚠️ 9. Rules & Common Mistakes

### ❌ NEVER Do

| Rule | Explanation |
|------|-------------|
| Use `Provider`/`Riverpod`/`Bloc`/`MobX` | This project uses RxDart exclusively |
| Call API from UI directly | Always go through the Rx controller |
| Use raw `Dio()` | Use `getHttp()`/`postHttp()` wrappers from `dio.dart` |
| Hardcode URLs in api.dart | Use `Endpoints.*` from `endpoints.dart` |
| Use `StreamController` | Use `BehaviorSubject` (replays last value) |
| Create Rx objects inside widgets | Register globally in `api_acess.dart` |
| Forget try/catch in Rx methods | Always wrap API calls in try/catch |

### ✅ ALWAYS Do

| Rule | Explanation |
|------|-------------|
| Extend `RxResponseInt` | All Rx controllers inherit from the base class |
| Override `handleSuccessWithReturn` | Customize success behavior per feature |
| Override `handleErrorWithReturn` | Customize error handling per feature |
| Use `ValueStream get fileData =>` | Expose the stream as a `ValueStream` getter |
| Register in `api_acess.dart` | One global instance per Rx class |
| Use `StreamBuilder` in UI | The pattern for observing Rx streams |

---

## 📚 10. Quick Reference: New API Checklist

- [ ] `lib/networks/endpoints.dart` — add `static String myEndpoint() => "/path";`
- [ ] `lib/features/[name]/data/rx_[verb]_[name]/api.dart` — singleton API class
- [ ] `lib/features/[name]/data/rx_[verb]_[name]/rx.dart` — Rx controller extending `RxResponseInt`
- [ ] `lib/networks/api_acess.dart` — register `MyRx myRxObj = MyRx(empty: {}, dataFetcher: BehaviorSubject<Map>());`
- [ ] `lib/features/[name]/presentation/screen.dart` — `StreamBuilder` consuming the stream
- [ ] `test/features/[name]/screen_test.dart` — widget test (see Testing & Architecture Analyzer skill)
