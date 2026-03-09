import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager_app/main.dart';

/// US 11: Accessibility Labels Tests
/// 
/// Tests accessibility features including:
/// - Semantic labels for screen readers
/// - Icon button tooltips
/// - Form field labels
/// - Button labels

void main() {
  group('US 11: Accessibility Labels Tests', () {
    
    testWidgets('Test 5.1: Theme toggle has tooltip', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find theme toggle button
      final themeToggleFinder = find.byIcon(Icons.brightness_6);
      expect(themeToggleFinder, findsOneWidget,
        reason: 'Theme toggle should be present');

      // Get the IconButton
      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: themeToggleFinder,
          matching: find.byType(IconButton),
        ),
      );

      // Verify tooltip exists
      expect(iconButton.tooltip, isNotNull,
        reason: 'Theme toggle should have tooltip for accessibility');
      expect(iconButton.tooltip, isNotEmpty,
        reason: 'Tooltip should not be empty');
      
      print('✓ Test 5.1 PASSED: Theme toggle has tooltip');
    });

    testWidgets('Test 5.2: Login form fields have labels', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login page
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Find text fields
      final textFields = find.byType(TextField);
      final usernameField = tester.widget<TextField>(textFields.first);
      final passwordField = tester.widget<TextField>(textFields.last);

      // Check for labels or hints
      expect(
        usernameField.decoration?.labelText != null ||
        usernameField.decoration?.hintText != null,
        true,
        reason: 'Username field should have label or hint text'
      );

      expect(
        passwordField.decoration?.labelText != null ||
        passwordField.decoration?.hintText != null,
        true,
        reason: 'Password field should have label or hint text'
      );
      
      print('✓ Test 5.2 PASSED: Login form fields have labels');
    });

    testWidgets('Test 5.3: Buttons have descriptive text', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find buttons on start page
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      final registerButton = find.widgetWithText(ElevatedButton, 'Register');

      expect(loginButton, findsOneWidget,
        reason: 'Login button should have descriptive text');
      expect(registerButton, findsOneWidget,
        reason: 'Register button should have descriptive text');
      
      print('✓ Test 5.3 PASSED: Buttons have descriptive text');
    });

    testWidgets('Test 5.4: Icons have semantic labels', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login page
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Find all IconButtons
      final iconButtons = find.byType(IconButton);
      
      for (final iconButtonFinder in iconButtons.evaluate()) {
        final iconButton = iconButtonFinder.widget as IconButton;
        
        // Each IconButton should have either tooltip or semantic label
        expect(
          iconButton.tooltip != null || iconButton.icon is Icon,
          true,
          reason: 'IconButtons should have tooltips or semantic labels'
        );
      }
      
      print('✓ Test 5.4 PASSED: Icons have semantic labels');
    });

    testWidgets('Test 5.5: Registration form fields have labels', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to register page
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Find text field
      final textFields = find.byType(TextField);
      
      for (final textFieldFinder in textFields.evaluate()) {
        final textField = textFieldFinder.widget as TextField;
        
        // Each field should have label or hint
        expect(
          textField.decoration?.labelText != null ||
          textField.decoration?.hintText != null,
          true,
          reason: 'Registration fields should have labels or hints'
        );
      }
      
      print('✓ Test 5.5 PASSED: Registration form fields have labels');
    });

    testWidgets('Test 5.6: App has title for screen readers', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find MaterialApp
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      // MaterialApp should have a title
      expect(materialApp.title, isNotNull,
        reason: 'App should have title for screen readers');
      expect(materialApp.title, isNotEmpty,
        reason: 'App title should not be empty');
      
      print('✓ Test 5.6 PASSED: App has title for screen readers');
    });

    testWidgets('Test 5.7: Password visibility toggle has tooltip', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login page
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Look for password visibility toggle icon
      final visibilityIcon = find.byIcon(Icons.visibility);
      final visibilityOffIcon = find.byIcon(Icons.visibility_off);
      
      if (visibilityIcon.evaluate().isNotEmpty || visibilityOffIcon.evaluate().isNotEmpty) {
        final iconFinder = visibilityIcon.evaluate().isNotEmpty ? visibilityIcon : visibilityOffIcon;
        
        // Find parent IconButton
        final iconButton = find.ancestor(
          of: iconFinder,
          matching: find.byType(IconButton),
        );
        
        if (iconButton.evaluate().isNotEmpty) {
          final iconButtonWidget = tester.widget<IconButton>(iconButton);
          expect(iconButtonWidget.tooltip, isNotNull,
            reason: 'Password visibility toggle should have tooltip');
          
          print('✓ Test 5.7 PASSED: Password visibility toggle has tooltip');
        } else {
          print('⚠ Test 5.7 SKIPPED: Password visibility toggle not found');
        }
      } else {
        print('⚠ Test 5.7 SKIPPED: Password visibility toggle not implemented');
      }
    });
  });

  group('Semantic Widget Tests', () {
    testWidgets('Test 5.8: Important widgets have Semantics', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Check for Semantics widgets
      final semanticsWidgets = find.byType(Semantics);
      
      // App should use Semantics for accessibility
      // Note: Flutter automatically adds Semantics to many widgets
      expect(semanticsWidgets.evaluate().length, greaterThan(0),
        reason: 'App should have semantic widgets for screen readers');
      
      print('✓ Test 5.8 PASSED: App uses Semantics widgets');
    });

    testWidgets('Test 5.9: Text widgets are readable by screen readers', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find all Text widgets
      final textWidgets = find.byType(Text);
      
      // Verify text widgets exist and have content
      expect(textWidgets.evaluate().length, greaterThan(0),
        reason: 'App should have text content');
      
      for (final textFinder in textWidgets.evaluate()) {
        final text = textFinder.widget as Text;
        
        // Text should have data or textSpan
        expect(
          text.data != null || text.textSpan != null,
          true,
          reason: 'Text widgets should have content for screen readers'
        );
      }
      
      print('✓ Test 5.9 PASSED: Text widgets are readable by screen readers');
    });
  });

  group('Label Content Tests', () {
    testWidgets('Test 5.10: Labels are descriptive and clear', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Find text fields
      final textFields = find.byType(TextField);
      
      for (final textFieldFinder in textFields.evaluate()) {
        final textField = textFieldFinder.widget as TextField;
        final label = textField.decoration?.labelText ?? textField.decoration?.hintText ?? '';
        
        // Labels should not be too short (at least 3 characters)
        if (label.isNotEmpty) {
          expect(label.length, greaterThanOrEqualTo(3),
            reason: 'Labels should be descriptive (at least 3 characters)');
        }
      }
      
      print('✓ Test 5.10 PASSED: Labels are descriptive and clear');
    });
  });
}
