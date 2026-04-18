// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:template_flutter/features/auth/presentation/signup.dart';

// import '../../helpers/test_helpers.dart';

// void main() {
//   setUpAll(() async {
//     await setUpTestDependencies();
//   });

//   tearDownAll(() async {
//     await tearDownTestDependencies();
//   });

//   group('SignUpScreen', () {
//     testWidgets('renders the screen without errors',
//         (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const SignUpScreen()));
//       await tester.pumpAndSettle();

//       expect(find.byType(Scaffold), findsWidgets);
//     });

//     testWidgets('displays "Create Account" title', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const SignUpScreen()));
//       await tester.pumpAndSettle();

//       expect(find.text('Create Account'), findsWidgets);
//     });

//     testWidgets('has all 5 form fields (name, email, phone, password, confirm)',
//         (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const SignUpScreen()));
//       await tester.pumpAndSettle();

//       // 5 TextFormFields: name, email, phone, password, confirm password
//       expect(find.byType(TextFormField), findsNWidgets(5));
//     });

//     testWidgets('has terms and conditions checkbox',
//         (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const SignUpScreen()));
//       await tester.pumpAndSettle();

//       expect(find.byType(Checkbox), findsOneWidget);
//     });

//     testWidgets('checkbox is initially unchecked', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const SignUpScreen()));
//       await tester.pumpAndSettle();

//       final Checkbox checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
//       expect(checkbox.value, isFalse);
//     });

//     testWidgets('can toggle terms checkbox', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const SignUpScreen()));
//       await tester.pumpAndSettle();

//       // Checkbox is far down the scrollable form — scroll it into view first
//       await tester.ensureVisible(find.byType(Checkbox));
//       await tester.pumpAndSettle();

//       await tester.tap(find.byType(Checkbox));
//       await tester.pump();

//       final Checkbox checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
//       expect(checkbox.value, isTrue);
//     });

//     testWidgets('has "Sign In" navigation link', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const SignUpScreen()));
//       await tester.pumpAndSettle();

//       // "Sign In" is inside a RichText TextSpan (CustomRichTextButton),
//       // so find.text() won't work. Search within RichText widgets instead.
//       final Finder richTextFinder = find.byWidgetPredicate((Widget widget) {
//         if (widget is RichText) {
//           final String text = widget.text.toPlainText();
//           return text.contains('Sign In');
//         }
//         return false;
//       });
//       expect(richTextFinder, findsOneWidget);
//     });

//     testWidgets('has back button', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const SignUpScreen()));
//       await tester.pumpAndSettle();

//       expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
//     });

//     testWidgets('has "Or" divider', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const SignUpScreen()));
//       await tester.pumpAndSettle();

//       expect(find.text('Or'), findsOneWidget);
//     });

//     testWidgets('can enter text into name field', (WidgetTester tester) async {
//       await tester.pumpWidget(testableWidget(const SignUpScreen()));
//       await tester.pumpAndSettle();

//       final Finder nameField = find.byType(TextFormField).first;
//       await tester.enterText(nameField, 'John Doe');
//       await tester.pump();

//       expect(find.text('John Doe'), findsOneWidget);
//     });
//   });
// }
