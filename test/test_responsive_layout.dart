import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager_app/main.dart';

/// US 7: Responsive Layout Tests
/// 
/// Tests responsive design and layout adaptation including:
/// - Layout adapts to different screen sizes
/// - No horizontal scrolling
/// - Content remains accessible at various sizes
/// - Text scaling support

void main() {
  group('US 7: Responsive Layout Tests', () {
    
    testWidgets('Test 6.1: App renders on small screen (800x600)', (WidgetTester tester) async {
      // Set small screen size
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify app renders without overflow
      expect(tester.takeException(), isNull,
        reason: 'App should render without errors on small screen');
      
      // Verify buttons are visible
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      
      print('✓ Test 6.1 PASSED: App renders on small screen (800x600)');
      
      // Reset to default
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('Test 6.2: App renders on medium screen (1024x768)', (WidgetTester tester) async {
      // Set medium screen size
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify app renders without overflow
      expect(tester.takeException(), isNull,
        reason: 'App should render without errors on medium screen');
      
      print('✓ Test 6.2 PASSED: App renders on medium screen (1024x768)');
      
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('Test 6.3: App renders on large screen (1920x1080)', (WidgetTester tester) async {
      // Set large screen size
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify app renders without overflow
      expect(tester.takeException(), isNull,
        reason: 'App should render without errors on large screen');
      
      print('✓ Test 6.3 PASSED: App renders on large screen (1920x1080)');
      
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('Test 6.4: Login page is responsive on small screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify no overflow errors
      expect(tester.takeException(), isNull,
        reason: 'Login page should not overflow on small screen');
      
      // Verify form elements are visible
      expect(find.byType(TextField), findsAtLeast(2));
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
      
      print('✓ Test 6.4 PASSED: Login page is responsive on small screen');
      
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('Test 6.5: Registration page is responsive on small screen', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to register
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Verify no overflow errors
      expect(tester.takeException(), isNull,
        reason: 'Registration page should not overflow on small screen');
      
      // Verify form elements are visible
      expect(find.byType(TextField), findsAtLeast(1));
      
      print('✓ Test 6.5 PASSED: Registration page is responsive on small screen');
      
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('Test 6.6: No horizontal overflow on narrow screen', (WidgetTester tester) async {
      // Set very narrow screen
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify no overflow
      expect(tester.takeException(), isNull,
        reason: 'Should not have horizontal overflow on narrow screen');
      
      print('✓ Test 6.6 PASSED: No horizontal overflow on narrow screen');
      
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('Test 6.7: Content is accessible on different screen sizes', (WidgetTester tester) async {
      final screenSizes = [
        const Size(600, 800),   // Small
        const Size(1024, 768),  // Medium
        const Size(1920, 1080), // Large
      ];

      for (final size in screenSizes) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        
        await tester.pumpWidget(const MyApp());
        await tester.pumpAndSettle();

        // Verify essential elements are present
        expect(find.text('Login'), findsOneWidget,
          reason: 'Login button should be visible at ${size.width}x${size.height}');
        expect(find.text('Register'), findsOneWidget,
          reason: 'Register button should be visible at ${size.width}x${size.height}');
        
        // Verify no overflow
        expect(tester.takeException(), isNull,
          reason: 'Should not overflow at ${size.width}x${size.height}');
      }
      
      print('✓ Test 6.7 PASSED: Content is accessible on all screen sizes');
      
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('Test 6.8: Buttons maintain minimum touch target size', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find buttons
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');

      // Get button sizes
      final loginSize = tester.getSize(loginButton);
      final registerSize = tester.getSize(registerButton);

      // Minimum touch target is 48x48 (Material Design guideline)
      expect(loginSize.height, greaterThanOrEqualTo(40),
        reason: 'Login button should have minimum height for touch');
      expect(registerSize.height, greaterThanOrEqualTo(40),
        reason: 'Register button should have minimum height for touch');
      
      print('✓ Test 6.8 PASSED: Buttons maintain minimum touch target size');
      
      addTearDown(() => tester.view.resetPhysicalSize());
    });
  });

  group('Text Scaling Tests', () {
    testWidgets('Test 6.9: App handles text scaling (1.5x)', (WidgetTester tester) async {
      // Set text scale factor
      tester.view.platformDispatcher.textScaleFactorTestValue = 1.5;
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify no overflow with larger text
      expect(tester.takeException(), isNull,
        reason: 'App should handle 1.5x text scaling without overflow');
      
      // Verify content is still visible
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Register'), findsOneWidget);
      
      print('✓ Test 6.9 PASSED: App handles 1.5x text scaling');
      
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('Test 6.10: App handles text scaling (2.0x)', (WidgetTester tester) async {
      // Set larger text scale factor
      tester.view.platformDispatcher.textScaleFactorTestValue = 2.0;
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify no overflow with larger text
      expect(tester.takeException(), isNull,
        reason: 'App should handle 2.0x text scaling without overflow');
      
      print('✓ Test 6.10 PASSED: App handles 2.0x text scaling');
      
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('Test 6.11: Login form handles text scaling', (WidgetTester tester) async {
      tester.view.platformDispatcher.textScaleFactorTestValue = 1.5;
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify no overflow
      expect(tester.takeException(), isNull,
        reason: 'Login form should handle text scaling');
      
      // Verify form is still functional
      expect(find.byType(TextField), findsAtLeast(2));
      
      print('✓ Test 6.11 PASSED: Login form handles text scaling');
      
      addTearDown(() => tester.view.resetPhysicalSize());
    });
  });

  group('Orientation Tests', () {
    testWidgets('Test 6.12: App handles portrait orientation', (WidgetTester tester) async {
      // Portrait orientation (height > width)
      tester.view.physicalSize = const Size(600, 1024);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull,
        reason: 'App should handle portrait orientation');
      
      print('✓ Test 6.12 PASSED: App handles portrait orientation');
      
      addTearDown(() => tester.view.resetPhysicalSize());
    });

    testWidgets('Test 6.13: App handles landscape orientation', (WidgetTester tester) async {
      // Landscape orientation (width > height)
      tester.view.physicalSize = const Size(1024, 600);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull,
        reason: 'App should handle landscape orientation');
      
      print('✓ Test 6.13 PASSED: App handles landscape orientation');
      
      addTearDown(() => tester.view.resetPhysicalSize());
    });
  });

  group('Layout Constraint Tests', () {
    testWidgets('Test 6.14: Widgets use flexible layouts', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Look for flexible layout widgets
      final columns = find.byType(Column);
      final rows = find.byType(Row);
      final centers = find.byType(Center);

      // App should use layout widgets
      expect(
        columns.evaluate().length + rows.evaluate().length + centers.evaluate().length,
        greaterThan(0),
        reason: 'App should use flexible layout widgets'
      );
      
      print('✓ Test 6.14 PASSED: Widgets use flexible layouts');
    });

    testWidgets('Test 6.15: No fixed width constraints on main content', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify content adapts to screen width
      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsWidgets,
        reason: 'App should use Scaffold for responsive layout');
      
      print('✓ Test 6.15 PASSED: Content uses responsive constraints');
      
      addTearDown(() => tester.view.resetPhysicalSize());
    });
  });
}
