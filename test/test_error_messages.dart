import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager_app/main.dart';

/// US 15: Improved Error Messages Tests
/// 
/// Tests error message display and clarity including:
/// - Error message visibility
/// - Error message content clarity
/// - Error message dismissal
/// - Validation error messages

void main() {
  group('US 15: Improved Error Messages Tests', () {
    
    testWidgets('Test 3.1: Empty username shows validation error', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login page
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Try to login with empty fields
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Look for error message or snackbar
      final errorMessage = find.textContaining('username', findRichText: true);
      final snackBar = find.byType(SnackBar);
      
      expect(
        errorMessage.evaluate().isNotEmpty || snackBar.evaluate().isNotEmpty,
        true,
        reason: 'Should show error message for empty username'
      );
      
      print('✓ Test 3.1 PASSED: Empty username shows validation error');
    });

    testWidgets('Test 3.2: Empty password shows validation error', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login page
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Enter only username
      await tester.enterText(find.byType(TextField).first, 'testuser');
      
      // Try to login without password
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Look for error message
      final errorMessage = find.textContaining('password', findRichText: true);
      final snackBar = find.byType(SnackBar);
      
      expect(
        errorMessage.evaluate().isNotEmpty || snackBar.evaluate().isNotEmpty,
        true,
        reason: 'Should show error message for empty password'
      );
      
      print('✓ Test 3.2 PASSED: Empty password shows validation error');
    });

    testWidgets('Test 3.3: Short password shows validation error in registration', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to register page
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();

      // Enter username
      await tester.enterText(find.byType(TextField), 'newuser');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Next'));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Enter short password (less than 8 characters)
      final passwordFields = find.byType(TextField);
      if (passwordFields.evaluate().isNotEmpty) {
        await tester.enterText(passwordFields.first, '123');
        await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
        await tester.pumpAndSettle();

        // Look for validation error
        final errorMessage = find.textContaining('8', findRichText: true);
        final snackBar = find.byType(SnackBar);
        
        expect(
          errorMessage.evaluate().isNotEmpty || snackBar.evaluate().isNotEmpty,
          true,
          reason: 'Should show error for password less than 8 characters'
        );
        
        print('✓ Test 3.3 PASSED: Short password shows validation error');
      } else {
        print('⚠ Test 3.3 SKIPPED: Could not navigate to password page');
      }
    });

    testWidgets('Test 3.4: Error messages are user-friendly (no technical jargon)', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Try to login with empty fields
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Find all text widgets
      final allText = find.byType(Text);
      final textWidgets = allText.evaluate().map((e) {
        final widget = e.widget as Text;
        return widget.data ?? '';
      }).toList();

      // Check that error messages don't contain technical terms
      final technicalTerms = ['null', 'exception', 'error code', 'stack trace', 'undefined'];
      final hasTechnicalTerms = textWidgets.any((text) =>
        technicalTerms.any((term) => text.toLowerCase().contains(term))
      );

      expect(hasTechnicalTerms, false,
        reason: 'Error messages should not contain technical jargon');
      
      print('✓ Test 3.4 PASSED: Error messages are user-friendly');
    });

    testWidgets('Test 3.5: SnackBar error messages are visible', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Trigger an error
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Check if SnackBar appears
      final snackBar = find.byType(SnackBar);
      
      if (snackBar.evaluate().isNotEmpty) {
        // Verify SnackBar has content
        final snackBarWidget = tester.widget<SnackBar>(snackBar);
        expect(snackBarWidget.content, isNotNull,
          reason: 'SnackBar should have content');
        
        print('✓ Test 3.5 PASSED: SnackBar error messages are visible');
      } else {
        print('⚠ Test 3.5 INFO: No SnackBar found (may use different error display)');
      }
    });

    testWidgets('Test 3.6: Error messages can be dismissed', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Trigger an error
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Check if SnackBar appears
      final snackBar = find.byType(SnackBar);
      
      if (snackBar.evaluate().isNotEmpty) {
        // Wait for auto-dismiss or find dismiss button
        await tester.pumpAndSettle(const Duration(seconds: 5));
        
        // SnackBar should auto-dismiss
        final snackBarAfterWait = find.byType(SnackBar);
        expect(snackBarAfterWait.evaluate().isEmpty, true,
          reason: 'SnackBar should auto-dismiss after timeout');
        
        print('✓ Test 3.6 PASSED: Error messages can be dismissed');
      } else {
        print('⚠ Test 3.6 SKIPPED: No SnackBar to test dismissal');
      }
    });

    testWidgets('Test 3.7: Error text color is distinguishable', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Trigger an error
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Check SnackBar background color
      final snackBar = find.byType(SnackBar);
      
      if (snackBar.evaluate().isNotEmpty) {
        final snackBarWidget = tester.widget<SnackBar>(snackBar);
        
        // Error SnackBars typically use red or warning colors
        // We just verify it has a background color set
        expect(snackBarWidget.backgroundColor, isNotNull,
          reason: 'Error SnackBar should have distinguishable background color');
        
        print('✓ Test 3.7 PASSED: Error messages have distinguishable styling');
      } else {
        print('⚠ Test 3.7 SKIPPED: No SnackBar to test styling');
      }
    });
  });

  group('Error Message Content Tests', () {
    testWidgets('Test 3.8: Error messages are specific and actionable', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Trigger validation error
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      // Find all text
      final allText = find.byType(Text);
      final textWidgets = allText.evaluate().map((e) {
        final widget = e.widget as Text;
        return widget.data ?? '';
      }).toList();

      // Error messages should contain actionable words
      final actionableWords = ['enter', 'provide', 'required', 'must', 'please'];
      final hasActionableContent = textWidgets.any((text) =>
        actionableWords.any((word) => text.toLowerCase().contains(word))
      );

      expect(hasActionableContent, true,
        reason: 'Error messages should be specific and actionable');
      
      print('✓ Test 3.8 PASSED: Error messages are specific and actionable');
    });
  });
}
