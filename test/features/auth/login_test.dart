// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:template_flutter/features/auth/presentation/login.dart';

// import '../../helpers/test_helpers.dart';

// void main() {
//   setUpAll(() async {
//     await setUpTestDependencies();
//   });

//   tearDownAll(() async {
//     await tearDownTestDependencies();
//   });

//   group('LoginScreen', () {
//     testWidgets('renders the screen without errors',
//         (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const LoginScreen()));
//       await tester.pumpAndSettle();

//       // Screen should render — Scaffold exists
//       expect(find.byType(Scaffold), findsWidgets);
//     });

//     testWidgets('displays "Welcome Back" title', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const LoginScreen()));
//       await tester.pumpAndSettle();

//       expect(find.text('Welcome Back'), findsOneWidget);
//     });

//     testWidgets('displays subtitle text', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const LoginScreen()));
//       await tester.pumpAndSettle();

//       expect(find.text('Please sign in to your account'), findsOneWidget);
//     });

//     testWidgets('has email and password form fields',
//         (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const LoginScreen()));
//       await tester.pumpAndSettle();

//       // Check for TextFormFields (email + password = 2)
//       expect(find.byType(TextFormField), findsNWidgets(2));
//     });

//     testWidgets('has "Sign In" button', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const LoginScreen()));
//       await tester.pumpAndSettle();

//       expect(find.text('Sign In'), findsWidgets);
//     });

//     testWidgets('has "Sign Up" navigation link', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const LoginScreen()));
//       await tester.pumpAndSettle();

//       // "Sign Up" is inside a RichText TextSpan (CustomRichTextButton)
//       final Finder richTextFinder = find.byWidgetPredicate((Widget widget) {
//         if (widget is RichText) {
//           return widget.text.toPlainText().contains('Sign Up');
//         }
//         return false;
//       });
//       expect(richTextFinder, findsOneWidget);
//     });

//     testWidgets('has "Forgot password?" link', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const LoginScreen()));
//       await tester.pumpAndSettle();

//       expect(find.text('Forgot password?'), findsOneWidget);
//     });

//     testWidgets('has "Or" divider text', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const LoginScreen()));
//       await tester.pumpAndSettle();

//       expect(find.text('Or'), findsOneWidget);
//     });

//     testWidgets('can enter text into form fields', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const LoginScreen()));
//       await tester.pumpAndSettle();

//       final Finder emailField = find.byType(TextFormField).first;
//       await tester.enterText(emailField, 'user@example.com');
//       await tester.pump();

//       expect(find.text('user@example.com'), findsOneWidget);
//     });
//   });
// }
