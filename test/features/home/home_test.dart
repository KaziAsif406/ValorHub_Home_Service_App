import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_flutter/features/customer/home/presentation/home.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('renders without errors', (WidgetTester tester) async {
      await tester.pumpWidget(simpleTestableWidget(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('displays home screen title', (WidgetTester tester) async {
      await tester.pumpWidget(simpleTestableWidget(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Find a Trusted Service Professional'), findsOneWidget);
    });

    testWidgets('shows the search button', (WidgetTester tester) async {
      await tester.pumpWidget(simpleTestableWidget(const HomeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Search'), findsWidgets);
    });
  });
}
