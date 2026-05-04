// ignore_for_file: avoid_print
/// ============================================================================
/// Flutter Template — Architecture Analyzer
/// ============================================================================
/// A standalone Dart CLI script that statically audits project structure,
/// code quality, API/Rx patterns, naming conventions, and architectural
/// compliance against the rules defined in SKILL.md.
///
/// Usage:  dart run tool/analyze_architecture.dart
///         dart run tool/analyze_architecture.dart --verbose
/// ============================================================================
library;

import 'dart:io';

// ─── ANSI Colors ─────────────────────────────────────────────────────────────

const String _reset = '\x1B[0m';
const String _bold = '\x1B[1m';
const String _red = '\x1B[31m';
const String _green = '\x1B[32m';
const String _yellow = '\x1B[33m';
const String _cyan = '\x1B[36m';
const String _dim = '\x1B[2m';
const String _magenta = '\x1B[35m';

// ─── Result Model ────────────────────────────────────────────────────────────

enum Severity { pass, warning, fail }

class CheckResult {
  final Severity severity;
  final String category;
  final String message;
  final String? detail;

  const CheckResult(this.severity, this.category, this.message, [this.detail]);

  String get icon {
    switch (severity) {
      case Severity.pass:
        return '✅';
      case Severity.warning:
        return '⚠️';
      case Severity.fail:
        return '❌';
    }
  }
}

// ─── Globals ─────────────────────────────────────────────────────────────────

bool verbose = false;
final List<CheckResult> results = [];

void pass(String cat, String msg) =>
    results.add(CheckResult(Severity.pass, cat, msg));
void warn(String cat, String msg, [String? detail]) =>
    results.add(CheckResult(Severity.warning, cat, msg, detail));
void fail(String cat, String msg, [String? detail]) =>
    results.add(CheckResult(Severity.fail, cat, msg, detail));

// ─── Utilities ───────────────────────────────────────────────────────────────

String _rel(String absPath, String root) {
  if (absPath.startsWith(root)) {
    String r = absPath.substring(root.length);
    if (r.startsWith('/') || r.startsWith('\\')) r = r.substring(1);
    return r;
  }
  return absPath;
}

List<FileSystemEntity> _dartFiles(Directory dir) {
  if (!dir.existsSync()) return [];
  return dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();
}

String _removeComments(String source) {
  // Remove single-line comments
  String result = source.replaceAll(RegExp(r'//.*'), '');
  // Remove multi-line comments
  result = result.replaceAll(RegExp(r'/\*[\s\S]*?\*/', multiLine: true), '');
  return result;
}

/// Returns true if a file is entirely commented out (no meaningful code).
/// A file is considered "fully commented" if removing all comments and
/// whitespace leaves nothing (or only import-like leftovers under 20 chars).
bool _isFullyCommentedOut(String source) {
  final String stripped = _removeComments(source).trim();
  return stripped.isEmpty || stripped.length < 20;
}

// ─── 1. Project Structure Checks ────────────────────────────────────────────

void checkProjectStructure(Directory libDir) {
  const String cat = 'Structure';
  final Directory featuresDir = Directory('${libDir.path}/features');

  if (!featuresDir.existsSync()) {
    fail(cat, 'Missing lib/features/ directory');
    return;
  }

  final List<Directory> features = featuresDir
      .listSync()
      .whereType<Directory>()
      .where((d) => !d.path.endsWith('.DS_Store'))
      .toList();

  if (features.isEmpty) {
    fail(cat, 'No feature directories found under lib/features/');
    return;
  }

  pass(cat,
      'Found ${features.length} feature(s): ${features.map((d) => d.path.split('/').last).join(', ')}');

  for (final Directory feature in features) {
    final String name = feature.path.split('/').last;
    final Directory dataDir = Directory('${feature.path}/data');
    final Directory presDir = Directory('${feature.path}/presentation');

    // Skip missing data/ — not every feature needs a data layer (e.g. home)
    if (!dataDir.existsSync()) {
    } else {
      // Check rx_* subdirectories
      final List<Directory> rxDirs = dataDir
          .listSync()
          .whereType<Directory>()
          .where((d) => d.path.split('/').last.startsWith('rx_'))
          .toList();

      if (rxDirs.isEmpty) {
        warn(cat, 'Feature "$name/data/" has no rx_* subdirectories');
      } else {
        for (final Directory rxDir in rxDirs) {
          final String rxName = rxDir.path.split('/').last;
          final File apiFile = File('${rxDir.path}/api.dart');
          final File rxFile = File('${rxDir.path}/rx.dart');

          if (!apiFile.existsSync()) {
            fail(cat, 'Missing api.dart in "$name/data/$rxName/"');
          }
          if (!rxFile.existsSync()) {
            fail(cat, 'Missing rx.dart in "$name/data/$rxName/"');
          }
          if (apiFile.existsSync() && rxFile.existsSync()) {
            pass(cat, '"$name/data/$rxName/" has both api.dart & rx.dart');
          }
        }
      }

      // Check naming convention
      final List<Directory> nonRxDirs = dataDir
          .listSync()
          .whereType<Directory>()
          .where((d) =>
              !d.path.split('/').last.startsWith('rx_') &&
              d.path.split('/').last != 'models' &&
              d.path.split('/').last != 'model')
          .toList();

      for (final Directory d in nonRxDirs) {
        warn(cat,
            'Non-standard directory in "$name/data/": "${d.path.split('/').last}" — should be rx_* or model(s)/');
      }
    }

    // Check presentation/ exists
    if (!presDir.existsSync()) {
      warn(cat, 'Feature "$name" is missing presentation/ directory');
    } else {
      final List<File> screens = presDir
          .listSync()
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList();
      if (screens.isEmpty) {
        warn(cat,
            'Feature "$name/presentation/" has no direct screen .dart files');
      } else {
        pass(cat,
            'Feature "$name/presentation/" has ${screens.length} screen file(s)');
      }
    }
  }
}

// ─── 2. API Layer Checks ────────────────────────────────────────────────────

void checkApiLayer(Directory libDir, String root) {
  const String cat = 'API Layer';
  final List<File> apiFiles = _dartFiles(Directory('${libDir.path}/features'))
      .whereType<File>()
      .where((f) => f.path.endsWith('/api.dart'))
      .toList()
      .cast<File>();

  if (apiFiles.isEmpty) {
    warn(cat, 'No api.dart files found');
    return;
  }

  for (final File file in apiFiles) {
    final String rel = _rel(file.path, root);
    final String content = file.readAsStringSync();

    // Skip files that are entirely commented out
    if (_isFullyCommentedOut(content)) {
      if (verbose) {
        warn(cat, '$rel is entirely commented out — skipping');
      }
      continue;
    }

    final String clean = _removeComments(content);

    // Singleton pattern
    if (clean.contains('_singleton') &&
        clean.contains('_internal') &&
        clean.contains('get instance')) {
      pass(cat, '$rel uses singleton pattern');
    } else {
      fail(cat, '$rel does NOT use the required singleton pattern',
          'Must have _singleton, _internal(), and get instance');
    }

    // Uses pre-configured Dio wrappers
    final RegExp dioWrappers =
        RegExp(r'\b(getHttp|postHttp|putHttp|deleteHttp)\b');
    if (dioWrappers.hasMatch(clean)) {
      pass(cat, '$rel uses pre-configured Dio HTTP wrappers');
    } else {
      fail(cat, '$rel does NOT use getHttp/postHttp/putHttp/deleteHttp',
          'Must import and use wrappers from networks/dio/dio.dart');
    }

    // Imports endpoints
    if (clean.contains('endpoints.dart')) {
      pass(cat, '$rel imports endpoints.dart');
    } else {
      fail(cat, '$rel does NOT import endpoints.dart',
          'Endpoint URLs must come from Endpoints class');
    }

    // No hardcoded URLs
    final RegExp hardcodedUrl =
        RegExp(r'''['"]https?://''', caseSensitive: false);
    if (hardcodedUrl.hasMatch(clean)) {
      fail(cat, '$rel contains hardcoded URL strings',
          'Move all URLs to endpoints.dart');
    } else {
      pass(cat, '$rel has no hardcoded URLs');
    }

    // DataSource error handling
    if (clean.contains('DataSource')) {
      pass(cat, '$rel references DataSource for error handling');
    } else {
      warn(cat, '$rel does not reference DataSource for error handling');
    }
  }
}

// ─── 3. Rx Layer Checks ─────────────────────────────────────────────────────

void checkRxLayer(Directory libDir, String root) {
  const String cat = 'Rx Layer';
  final List<File> rxFiles = _dartFiles(Directory('${libDir.path}/features'))
      .whereType<File>()
      .where((f) => f.path.endsWith('/rx.dart') && !f.path.contains('rx_base'))
      .toList()
      .cast<File>();

  if (rxFiles.isEmpty) {
    warn(cat, 'No rx.dart files found');
    return;
  }

  for (final File file in rxFiles) {
    final String rel = _rel(file.path, root);
    final String content = file.readAsStringSync();

    // Skip files that are entirely commented out
    if (_isFullyCommentedOut(content)) {
      if (verbose) {
        warn(cat, '$rel is entirely commented out — skipping');
      }
      continue;
    }

    final String clean = _removeComments(content);

    // Extends RxResponseInt
    if (clean.contains('extends RxResponseInt')) {
      pass(cat, '$rel extends RxResponseInt');
    } else {
      fail(cat, '$rel does NOT extend RxResponseInt',
          'All Rx classes must extend RxResponseInt from rx_base.dart');
    }

    // try/catch block
    if (RegExp(r'\btry\s*\{').hasMatch(clean) &&
        RegExp(r'\bcatch\s*\(').hasMatch(clean)) {
      pass(cat, '$rel has try/catch error handling');
    } else {
      fail(cat, '$rel is missing try/catch block in data-fetching method');
    }

    // handleSuccessWithReturn or handleErrorWithReturn
    if (clean.contains('handleSuccessWithReturn') ||
        clean.contains('handleErrorWithReturn')) {
      pass(cat, '$rel calls handleSuccessWithReturn/handleErrorWithReturn');
    } else {
      fail(cat,
          '$rel does NOT call handleSuccessWithReturn or handleErrorWithReturn');
    }

    // ValueStream getter
    if (clean.contains('ValueStream') || clean.contains('dataFetcher.stream')) {
      pass(cat, '$rel exposes stream via ValueStream getter');
    } else {
      warn(cat, '$rel may be missing a ValueStream getter for UI consumption');
    }

    // References its Api.instance
    if (RegExp(r'\w+Api\.instance').hasMatch(clean)) {
      pass(cat, '$rel references its corresponding Api.instance');
    } else {
      warn(cat, '$rel does not reference *Api.instance — verify API binding');
    }
  }
}

// ─── 4. Endpoint Centralization ─────────────────────────────────────────────

void checkEndpointCentralization(Directory libDir, String root) {
  const String cat = 'Endpoints';
  final List<File> allDart = _dartFiles(libDir).cast<File>();

  final RegExp hardcodedUrl =
      RegExp(r'''['"]https?://''', caseSensitive: false);
  // Matches strings like "/api/..." or "/auth/..." etc. that look like API paths
  final RegExp apiPathLiteral =
      RegExp(r'''['"]/(?:api|auth|user|products?|v\d)[/'"?]''');

  for (final File file in allDart) {
    final String rel = _rel(file.path, root);
    // Skip endpoints.dart itself, generated files, and dio.dart (has baseUrl usage)
    if (rel.contains('endpoints.dart') ||
        rel.contains('gen/') ||
        rel.contains('dio/dio.dart')) {
      continue;
    }

    final String clean = _removeComments(file.readAsStringSync());

    if (hardcodedUrl.hasMatch(clean)) {
      fail(cat, '$rel contains hardcoded URL — must use Endpoints class');
    }

    // Check for API path patterns in non-endpoint files (but only in data/ files)
    if (rel.contains('/data/') && apiPathLiteral.hasMatch(clean)) {
      warn(cat,
          '$rel may contain hardcoded API path literal — verify it uses Endpoints.*');
    }
  }

  // Check endpoints.dart exists
  final File endpointsFile = File('${libDir.path}/networks/endpoints.dart');
  if (endpointsFile.existsSync()) {
    pass(cat, 'endpoints.dart exists and centralizes API URLs');
    final String content = endpointsFile.readAsStringSync();
    final int count =
        RegExp(r'static\s+String\s+\w+').allMatches(content).length;
    pass(cat, 'endpoints.dart defines $count endpoint method(s)');
  } else {
    fail(cat, 'Missing lib/networks/endpoints.dart');
  }
}

// ─── 5. Code Quality & Style ────────────────────────────────────────────────

void checkCodeQuality(Directory libDir, String root) {
  const String cat = 'Code Quality';
  final List<File> presFiles = _dartFiles(libDir)
      .whereType<File>()
      .where((f) => f.path.contains('/presentation/'))
      .toList()
      .cast<File>();

  final List<File> featureFiles =
      _dartFiles(Directory('${libDir.path}/features')).cast<File>();

  // ── 5a. ScreenUtil compliance ──
  // We look for raw numeric layout values in presentation files.
  // Exclude: line-height (height: 1.5 in copyWith), childAspectRatio,
  // crossAxisCount, flex, strokeWidth, alpha, Offset values.
  //
  // Strategy: Match `property: <integer>` where the integer is NOT followed
  // by .h, .w, .r, or .sp. Decimal values (e.g. 1.5) are intentional
  // (line-height, aspect ratio) and are NOT flagged.
  final RegExp rawLayoutPattern = RegExp(
    r'(?:height|width|fontSize|letterSpacing)\s*:\s*(\d+)(?![\d.])',
  );
  final RegExp sizedBoxRaw = RegExp(
    r'SizedBox\s*\(\s*(?:height|width)\s*:\s*(\d+)(?![\d.])',
  );
  final RegExp edgeInsetsRaw = RegExp(
    r'EdgeInsets\.\w+\(\s*(\d+)(?![\d.])',
  );
  // Lines to skip — these use raw numbers intentionally
  final RegExp skipLinePattern = RegExp(
    r'(?:childAspectRatio|crossAxisCount|crossAxisSpacing|mainAxisSpacing|flex|strokeWidth|alpha|Offset|opacity|\.copyWith)\s*[:.(]',
  );

  int screenUtilViolations = 0;
  for (final File file in presFiles) {
    final String rel = _rel(file.path, root);
    final String clean = _removeComments(file.readAsStringSync());
    final List<String> lines = clean.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      // Skip lines that intentionally use raw numbers
      if (skipLinePattern.hasMatch(line)) continue;
      if (rawLayoutPattern.hasMatch(line) ||
          sizedBoxRaw.hasMatch(line) ||
          edgeInsetsRaw.hasMatch(line)) {
        screenUtilViolations++;
        if (verbose) {
          warn(cat,
              '$rel:${i + 1} — raw numeric layout value without .h/.w/.r/.sp');
        }
      }
    }
  }

  if (screenUtilViolations == 0) {
    pass(cat, 'No raw layout value violations found (ScreenUtil compliance)');
  } else {
    warn(cat,
        '$screenUtilViolations raw layout value(s) found without .h/.w/.r/.sp extension${!verbose ? " (run with --verbose for details)" : ""}');
  }

  // ── 5b. Color usage ──
  // Allow Colors.transparent, Colors.black, Colors.white — no need for AppColors
  final RegExp rawColors =
      RegExp(r'\bColors\.(?!transparent\b|black\b|white\b)\w+');
  int colorViolations = 0;
  List<String> colorFiles = [];
  for (final File file in featureFiles) {
    final String rel = _rel(file.path, root);
    final String clean = _removeComments(file.readAsStringSync());
    if (rawColors.hasMatch(clean)) {
      colorViolations++;
      colorFiles.add(rel);
    }
  }
  if (colorViolations == 0) {
    pass(cat,
        'No direct Colors.* usage in feature files — AppColors used correctly');
  } else {
    warn(
        cat,
        '$colorViolations file(s) use Colors.* directly — should use AppColors',
        colorFiles.take(5).join(', '));
  }

  // ── 5c. Navigation ──
  final RegExp navViolation =
      RegExp(r'Navigator\s*\.\s*(?:of|push|pop|replace)');
  int navViolations = 0;
  List<String> navFiles = [];
  for (final File file in featureFiles) {
    final String rel = _rel(file.path, root);
    final String clean = _removeComments(file.readAsStringSync());
    if (navViolation.hasMatch(clean)) {
      navViolations++;
      navFiles.add(rel);
    }
  }
  if (navViolations == 0) {
    pass(cat, 'No Navigator.of/push usage — NavigationService used correctly');
  } else {
    warn(
        cat,
        '$navViolations file(s) use Navigator directly — should use NavigationService',
        navFiles.take(5).join(', '));
  }

  // ── 5d. Forbidden state management ──
  final RegExp forbiddenState = RegExp(
      r"import\s+['" r""""]package:(?:provider|riverpod|flutter_bloc)/""");
  for (final File file in _dartFiles(libDir).cast<File>()) {
    final String rel = _rel(file.path, root);
    final String content = file.readAsStringSync();
    // Always check cleaned content — never match commented-out imports
    final String clean = _removeComments(content);
    if (clean.trim().isEmpty) continue;
    if (forbiddenState.hasMatch(clean)) {
      fail(
          cat,
          '$rel imports forbidden state management package (provider/riverpod/bloc)',
          'Only rxdart is allowed');
    }
  }
  pass(cat, 'No forbidden state management packages detected');

  // ── 5e. Type safety in API/Rx files ──
  final List<File> dataLayerFiles = _dartFiles(libDir)
      .whereType<File>()
      .where((f) =>
          (f.path.endsWith('/api.dart') || f.path.endsWith('/rx.dart')) &&
          f.path.contains('/features/'))
      .toList()
      .cast<File>();

  int dynamicCount = 0;
  for (final File file in dataLayerFiles) {
    final String rel = _rel(file.path, root);
    final String clean = _removeComments(file.readAsStringSync());
    // Count standalone 'var ' declarations (not in comments)
    final int vars = RegExp(r'\bvar\s+\w+').allMatches(clean).length;
    if (vars > 0) {
      warn(cat,
          '$rel has $vars untyped "var" declaration(s) — prefer explicit types');
      dynamicCount += vars;
    }
  }
  if (dynamicCount == 0) {
    pass(cat, 'No untyped var declarations in API/Rx files');
  }

  // ── 5f. Print usage ──
  final RegExp printUsage = RegExp(r'\bprint\s*\(');
  int printCount = 0;
  List<String> printFiles = [];
  for (final File file in featureFiles) {
    final String rel = _rel(file.path, root);
    // Skip generated files
    if (rel.contains('gen/')) continue;
    final String clean = _removeComments(file.readAsStringSync());
    final int matches = printUsage.allMatches(clean).length;
    if (matches > 0) {
      printCount += matches;
      printFiles.add('$rel ($matches)');
    }
  }
  if (printCount == 0) {
    pass(cat,
        'No raw print() usage in feature files — using dart:developer log()');
  } else {
    warn(cat, '$printCount print() call(s) found — prefer dart:developer log()',
        printFiles.take(5).join(', '));
  }
}

// ─── 6. DI & Route Registration ─────────────────────────────────────────────

void checkDiAndRoutes(Directory libDir, String root) {
  const String cat = 'DI & Routes';

  // ── 6a. api_access.dart — check all Rx objects have matching imports ──
  final File apiAccess = File('${libDir.path}/networks/api_acess.dart');
  if (apiAccess.existsSync()) {
    final String content = apiAccess.readAsStringSync();
    // Find all Rx class instantiations
    final RegExp rxInstantiation = RegExp(r'(\w+Rx)\s*\(');
    final Iterable<RegExpMatch> matches = rxInstantiation.allMatches(content);
    int registered = 0;
    for (final RegExpMatch _ in matches) {
      if (content.contains("import") && content.contains('rx.dart')) {
        registered++;
      }
    }
    pass(cat, 'api_access.dart registers $registered Rx object(s)');
  } else {
    // Try alternate name
    final File apiAccess2 = File('${libDir.path}/networks/api_access.dart');
    if (apiAccess2.existsSync()) {
      pass(cat, 'api_access.dart found (alternate spelling)');
    } else {
      warn(cat, 'Could not find api_acess.dart or api_access.dart');
    }
  }

  // ── 6b. all_routes.dart — check imports resolve to real files ──
  final File routesFile = File('${libDir.path}/helpers/all_routes.dart');
  if (!routesFile.existsSync()) {
    fail(cat, 'Missing lib/helpers/all_routes.dart');
    return;
  }

  final String routesContent = routesFile.readAsStringSync();
  final RegExp routeImport = RegExp(r"import\s+'([^']+)'\s*;");
  final Iterable<RegExpMatch> imports = routeImport.allMatches(routesContent);

  int validImports = 0;
  int invalidImports = 0;
  for (final RegExpMatch match in imports) {
    String importPath = match.group(1)!;
    // Resolve relative imports
    if (importPath.startsWith('../')) {
      // Resolve from helpers/ directory
      importPath = _resolveRelative('${libDir.path}/helpers', importPath);
    } else if (importPath.startsWith('package:')) {
      validImports++;
      continue;
    }
    if (File(importPath).existsSync()) {
      validImports++;
    } else {
      invalidImports++;
      fail(cat, 'all_routes.dart imports non-existent file: ${match.group(1)}');
    }
  }
  if (invalidImports == 0) {
    pass(
        cat, 'all_routes.dart — all $validImports import(s) resolve correctly');
  }

  // ── 6c. Check for orphaned features ──
  final Directory featuresDir = Directory('${libDir.path}/features');
  if (featuresDir.existsSync()) {
    final List<String> featureNames = featuresDir
        .listSync()
        .whereType<Directory>()
        .map((d) => d.path.split('/').last)
        .toList();

    // Features that don't need route registration
    const List<String> skipFeatures = ['home', 'example'];

    for (final String feature in featureNames) {
      if (skipFeatures.contains(feature)) continue;
      // Check if routes file references this feature's files
      if (!routesContent.contains('features/$feature/')) {
        warn(cat,
            'Feature "$feature" has no route registered in all_routes.dart — may be orphaned');
      }
    }
  }

  // ── 6d. di.dart exists ──
  final File diFile = File('${libDir.path}/helpers/di.dart');
  if (diFile.existsSync()) {
    final String diContent = diFile.readAsStringSync();
    if (diContent.contains('GetIt')) {
      pass(cat, 'di.dart uses GetIt for dependency injection');
    } else {
      warn(cat, 'di.dart does not reference GetIt');
    }
    if (diContent.contains('GetStorage')) {
      pass(cat, 'di.dart registers GetStorage');
    }
  } else {
    fail(cat, 'Missing lib/helpers/di.dart');
  }
}

String _resolveRelative(String fromDir, String relativePath) {
  final List<String> parts = fromDir.split('/');
  final List<String> relParts = relativePath.split('/');
  for (final String part in relParts) {
    if (part == '..') {
      parts.removeLast();
    } else if (part != '.') {
      parts.add(part);
    }
  }
  return parts.join('/');
}

// ─── 7. Common Widget Reuse ─────────────────────────────────────────────────

void checkCommonWidgets(Directory libDir, String root) {
  const String cat = 'Common Widgets';
  final Directory cwDir = Directory('${libDir.path}/common_widgets');

  if (!cwDir.existsSync()) {
    warn(cat, 'No lib/common_widgets/ directory found');
    return;
  }

  final List<File> widgets = cwDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();
  final List<String> widgetNames = widgets
      .map((f) => f.path.split('/').last.replaceAll('.dart', ''))
      .toList();

  pass(cat,
      'Found ${widgets.length} common widget(s): ${widgetNames.join(", ")}');

  // Check if any presentation file re-implements a TextFormField, Button, etc.
  // This is advisory — we only flag if they define classes with similar names
  final RegExp duplicateWidgets = RegExp(
    r'class\s+(?:Custom(?:Button|TextField|TextFormField|AppBar|Toast)|WaitingWidget|LoadingIndicator)',
    caseSensitive: false,
  );

  final List<File> presFiles = _dartFiles(libDir)
      .whereType<File>()
      .where((f) =>
          f.path.contains('/features/') && f.path.contains('/presentation/'))
      .toList()
      .cast<File>();

  for (final File file in presFiles) {
    final String rel = _rel(file.path, root);
    final String clean = _removeComments(file.readAsStringSync());
    if (duplicateWidgets.hasMatch(clean)) {
      warn(cat,
          '$rel defines a widget that may duplicate a common_widget — consider reusing');
    }
  }
}

// ─── 8. Bonus: pubspec.yaml Sanity ──────────────────────────────────────────

void checkPubspec(String root) {
  const String cat = 'Pubspec';
  final File pubspec = File('$root/pubspec.yaml');
  if (!pubspec.existsSync()) {
    fail(cat, 'pubspec.yaml not found at project root');
    return;
  }

  final String content = pubspec.readAsStringSync();

  // Check required dependencies
  final List<String> requiredDeps = [
    'rxdart',
    'dio',
    'get_it',
    'get_storage',
    'flutter_screenutil',
  ];
  for (final String dep in requiredDeps) {
    if (content.contains('$dep:')) {
      pass(cat, 'Required dependency "$dep" is present');
    } else {
      fail(cat, 'Missing required dependency: "$dep"');
    }
  }

  // Check dev_dependencies for mocktail
  if (content.contains('mocktail:')) {
    pass(cat, 'mocktail is present in dev_dependencies');
  } else {
    warn(cat, 'mocktail not found in dev_dependencies — needed for testing');
  }
}

// ─── Report ──────────────────────────────────────────────────────────────────

void printReport() {
  print('');
  print(
      '$_bold$_cyan╔══════════════════════════════════════════════════════════════╗$_reset');
  print(
      '$_bold$_cyan║          🔍  ARCHITECTURE ANALYSIS REPORT  🔍               ║$_reset');
  print(
      '$_bold$_cyan╚══════════════════════════════════════════════════════════════╝$_reset');
  print('');

  // Group by category
  final Map<String, List<CheckResult>> grouped = {};
  for (final CheckResult r in results) {
    grouped.putIfAbsent(r.category, () => []).add(r);
  }

  for (final MapEntry<String, List<CheckResult>> entry in grouped.entries) {
    final String category = entry.key;
    final List<CheckResult> checks = entry.value;
    final int passed = checks.where((c) => c.severity == Severity.pass).length;
    final int warnings =
        checks.where((c) => c.severity == Severity.warning).length;
    final int failures =
        checks.where((c) => c.severity == Severity.fail).length;

    String statusColor = _green;
    if (failures > 0) {
      statusColor = _red;
    } else if (warnings > 0) {
      statusColor = _yellow;
    }

    print(
        '$_bold$_magenta── $category $statusColor[$passed✅  $warnings⚠️  $failures❌]$_reset');
    print('');

    for (final CheckResult check in checks) {
      String color;
      switch (check.severity) {
        case Severity.pass:
          color = _green;
          break;
        case Severity.warning:
          color = _yellow;
          break;
        case Severity.fail:
          color = _red;
          break;
      }
      print('  $color${check.icon} ${check.message}$_reset');
      if (check.detail != null && check.detail!.isNotEmpty) {
        print('     $_dim↳ ${check.detail}$_reset');
      }
    }
    print('');
  }

  // Summary
  final int totalPassed =
      results.where((r) => r.severity == Severity.pass).length;
  final int totalWarnings =
      results.where((r) => r.severity == Severity.warning).length;
  final int totalFails =
      results.where((r) => r.severity == Severity.fail).length;
  final int total = results.length;

  print(
      '$_bold$_cyan══════════════════════════════════════════════════════════════$_reset');
  print('$_bold  📊  SCORE: $totalPassed / $total checks passed$_reset');
  print('$_green      ✅ Passed:   $totalPassed$_reset');
  print('$_yellow      ⚠️  Warnings: $totalWarnings$_reset');
  print('$_red      ❌ Failures: $totalFails$_reset');
  print(
      '$_bold$_cyan══════════════════════════════════════════════════════════════$_reset');
  print('');

  if (totalFails == 0 && totalWarnings == 0) {
    print('$_bold$_green  🎉 PERFECT! Your architecture is spotless.$_reset');
  } else if (totalFails == 0) {
    print(
        '$_bold$_yellow  ⚡ Good shape! $totalWarnings warning(s) to consider.$_reset');
  } else {
    print(
        '$_bold$_red  🚨 $totalFails failure(s) found. Please fix before shipping.$_reset');
  }
  print('');
}

// ─── Main ────────────────────────────────────────────────────────────────────

void main(List<String> args) {
  verbose = args.contains('--verbose') || args.contains('-v');

  // Resolve project root (script is in tool/)
  String root = Directory.current.path;

  // Verify we're in a Flutter project
  final File pubspec = File('$root/pubspec.yaml');
  if (!pubspec.existsSync()) {
    print(
        '$_red❌ pubspec.yaml not found. Run this from the project root.$_reset');
    print('   Usage: dart run tool/analyze_architecture.dart');
    exit(2);
  }

  final Directory libDir = Directory('$root/lib');
  if (!libDir.existsSync()) {
    print('$_red❌ lib/ directory not found.$_reset');
    exit(2);
  }

  print('');
  print('$_bold$_cyan🔬 Analyzing project: $root$_reset');
  print('$_dim   lib/ directory: ${libDir.path}$_reset');
  print('');

  // Run all checks
  checkProjectStructure(libDir);
  checkApiLayer(libDir, root);
  checkRxLayer(libDir, root);
  checkEndpointCentralization(libDir, root);
  checkCodeQuality(libDir, root);
  checkDiAndRoutes(libDir, root);
  checkCommonWidgets(libDir, root);
  checkPubspec(root);

  // Print report
  printReport();

  // Exit code
  final bool hasFails = results.any((r) => r.severity == Severity.fail);
  exit(hasFails ? 1 : 0);
}
