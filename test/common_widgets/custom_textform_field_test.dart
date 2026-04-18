// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:template_flutter/common_widgets/custom_textform_field.dart';

// import '../helpers/test_helpers.dart';

// void main() {
//   setUpAll(() async {
//     await setUpTestDependencies();
//   });

//   tearDownAll(() async {
//     await tearDownTestDependencies();
//   });

//   group('CustomTextFormField', () {
//     testWidgets('renders hint and label text', (WidgetTester tester) async {
//       final TextEditingController controller = TextEditingController();

//       await tester.pumpWidget(
//         simpleTestableWidget(
//           CustomTextFormField(
//             controller: controller,
//             hintText: 'Enter email',
//             labelText: 'Email',
//           ),
//         ),
//       );

//       expect(find.text('Email'), findsOneWidget);
//     });

//     testWidgets('accepts user input', (WidgetTester tester) async {
//       final TextEditingController controller = TextEditingController();

//       await tester.pumpWidget(
//         simpleTestableWidget(
//           CustomTextFormField(
//             controller: controller,
//             hintText: 'Type here',
//             labelText: 'Input',
//           ),
//         ),
//       );

//       await tester.enterText(find.byType(TextFormField), 'hello@test.com');
//       await tester.pump();

//       expect(controller.text, 'hello@test.com');
//     });

//     testWidgets('shows validation error when validator fails',
//         (WidgetTester tester) async {
//       final TextEditingController controller = TextEditingController();
//       final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//       await tester.pumpWidget(
//         simpleTestableWidget(
//           Form(
//             key: formKey,
//             child: CustomTextFormField(
//               controller: controller,
//               hintText: 'Enter value',
//               labelText: 'Required',
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'This field is required';
//                 }
//                 return null;
//               },
//             ),
//           ),
//         ),
//       );

//       // Trigger validation without entering text
//       formKey.currentState!.validate();
//       await tester.pump();

//       expect(find.text('This field is required'), findsOneWidget);
//     });

//     testWidgets('obscures text when isPassword is true',
//         (WidgetTester tester) async {
//       final TextEditingController controller = TextEditingController();

//       await tester.pumpWidget(
//         simpleTestableWidget(
//           CustomTextFormField(
//             controller: controller,
//             hintText: 'Enter password',
//             labelText: 'Password',
//             isPassword: true,
//           ),
//         ),
//       );

//       // TextFormField wraps a TextField — check obscureText on the TextField
//       final TextField textField =
//           tester.widget<TextField>(find.byType(TextField));
//       expect(textField.obscureText, isTrue);
//     });

//     testWidgets('does not obscure text when isPassword is false',
//         (WidgetTester tester) async {
//       final TextEditingController controller = TextEditingController();

//       await tester.pumpWidget(
//         simpleTestableWidget(
//           CustomTextFormField(
//             controller: controller,
//             hintText: 'Enter email',
//             labelText: 'Email',
//             isPassword: false,
//           ),
//         ),
//       );

//       final TextField textField =
//           tester.widget<TextField>(find.byType(TextField));
//       expect(textField.obscureText, isFalse);
//     });

//     testWidgets('renders prefix icon when provided',
//         (WidgetTester tester) async {
//       final TextEditingController controller = TextEditingController();

//       await tester.pumpWidget(
//         simpleTestableWidget(
//           CustomTextFormField(
//             controller: controller,
//             hintText: 'Enter email',
//             labelText: 'Email',
//             prefixIcon: Icons.email_outlined,
//           ),
//         ),
//       );

//       expect(find.byIcon(Icons.email_outlined), findsOneWidget);
//     });
//   });
// }
