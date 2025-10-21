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

    // Verify that app loads with title
    expect(find.text('Riwayat Data Sensor'), findsOneWidget);
    
    // Verify filter elements exist
    expect(find.text('Tanggal:'), findsOneWidget);
    expect(find.text('Telusuri'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    
    // Verify table headers exist
    expect(find.text('pH'), findsOneWidget);
    expect(find.text('Suhu'), findsOneWidget);
    expect(find.text('Mineral'), findsOneWidget);
    expect(find.text('Tanggal'), findsOneWidget);
    expect(find.text('Pukul'), findsOneWidget);
    
    // Reset for other tests
    addTearDown(tester.view.reset);
  });
  
  testWidgets('Date filter interaction test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    
    // Find and tap the Telusuri button without selecting date
    final telusuriButton = find.text('Telusuri');
    expect(telusuriButton, findsOneWidget);
    
    await tester.tap(telusuriButton);
    await tester.pump();
    
    // Should show snackbar message
    expect(find.text('Pilih tanggal terlebih dahulu'), findsOneWidget);
    
    addTearDown(tester.view.reset);
  });
  
  testWidgets('Reset button test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    
    // Find and tap the Reset button
    final resetButton = find.text('Reset');
    expect(resetButton, findsOneWidget);
    
    await tester.tap(resetButton);
    await tester.pumpAndSettle();
    
    // App should still be showing the main page
    expect(find.text('Riwayat Data Sensor'), findsOneWidget);
    
    addTearDown(tester.view.reset);
  });
}
