import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_framework/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Watrie app smoke test', (WidgetTester tester) async {
    // Set larger screen size for testing
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for async operations
    await tester.pumpAndSettle();

    // Verify that app loads with updated title
    expect(find.text('Status Kelayakan Air'), findsOneWidget);

    // Verify key labels exist
  expect(find.text('pH'), findsWidgets);
  expect(find.text('Suhu'), findsWidgets);
  expect(find.text('Mineral'), findsWidgets);

    // Reset for other tests
    addTearDown(tester.view.reset);
  });
}
