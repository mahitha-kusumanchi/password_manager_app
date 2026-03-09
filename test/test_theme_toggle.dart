import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:password_manager_app/main.dart';
import 'package:password_manager_app/providers/settings_provider.dart';

/// US 9: Light/Dark Mode Toggle Tests
/// 
/// Tests the theme switching functionality including:
/// - Theme toggle visibility
/// - Smooth transitions between themes
/// - Theme persistence
/// - Readability in both modes

void main() {
  group('US 9: Light/Dark Mode Toggle Tests', () {
    
    testWidgets('Test 1.1: Theme toggle button is visible on start page', (WidgetTester tester) async {
      // Build the app
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find the theme toggle button (IconButton with brightness icon)
      final themeToggleFinder = find.byIcon(Icons.brightness_6);
      
      // Verify theme toggle is visible
      expect(themeToggleFinder, findsOneWidget, 
        reason: 'Theme toggle button should be visible on start page');
      
      print('✓ Test 1.1 PASSED: Theme toggle button is visible');
    });

    testWidgets('Test 1.2: Theme switches from light to dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Get the settings provider
      final BuildContext context = tester.element(find.byType(MaterialApp));
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      
      // Verify initial theme is light
      expect(settingsProvider.isDarkMode, false, 
        reason: 'Initial theme should be light mode');

      // Find and tap the theme toggle button
      final themeToggleFinder = find.byIcon(Icons.brightness_6);
      await tester.tap(themeToggleFinder);
      await tester.pumpAndSettle();

      // Verify theme switched to dark
      expect(settingsProvider.isDarkMode, true, 
        reason: 'Theme should switch to dark mode after toggle');
      
      print('✓ Test 1.2 PASSED: Theme switches to dark mode');
    });

    testWidgets('Test 1.3: Theme switches back to light mode', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(MaterialApp));
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

      // Toggle to dark mode
      final themeToggleFinder = find.byIcon(Icons.brightness_6);
      await tester.tap(themeToggleFinder);
      await tester.pumpAndSettle();
      
      expect(settingsProvider.isDarkMode, true);

      // Toggle back to light mode
      await tester.tap(themeToggleFinder);
      await tester.pumpAndSettle();

      // Verify theme switched back to light
      expect(settingsProvider.isDarkMode, false, 
        reason: 'Theme should switch back to light mode');
      
      print('✓ Test 1.3 PASSED: Theme switches back to light mode');
    });

    testWidgets('Test 1.4: Theme toggle works on login page', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to login page
      final loginButtonFinder = find.text('Login');
      await tester.tap(loginButtonFinder);
      await tester.pumpAndSettle();

      // Find theme toggle on login page
      final themeToggleFinder = find.byIcon(Icons.brightness_6);
      expect(themeToggleFinder, findsOneWidget, 
        reason: 'Theme toggle should be visible on login page');

      // Test toggle functionality
      final BuildContext context = tester.element(find.byType(MaterialApp));
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      
      final initialTheme = settingsProvider.isDarkMode;
      await tester.tap(themeToggleFinder);
      await tester.pumpAndSettle();
      
      expect(settingsProvider.isDarkMode, !initialTheme, 
        reason: 'Theme should toggle on login page');
      
      print('✓ Test 1.4 PASSED: Theme toggle works on login page');
    });

    testWidgets('Test 1.5: MaterialApp theme data matches settings', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(MaterialApp));
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      // Verify light mode
      expect(settingsProvider.isDarkMode, false);
      expect(materialApp.theme?.brightness, Brightness.light,
        reason: 'MaterialApp should use light theme when isDarkMode is false');

      // Switch to dark mode
      final themeToggleFinder = find.byIcon(Icons.brightness_6);
      await tester.tap(themeToggleFinder);
      await tester.pumpAndSettle();

      // Get updated MaterialApp
      final updatedMaterialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      
      expect(settingsProvider.isDarkMode, true);
      expect(updatedMaterialApp.theme?.brightness, Brightness.dark,
        reason: 'MaterialApp should use dark theme when isDarkMode is true');
      
      print('✓ Test 1.5 PASSED: MaterialApp theme data matches settings');
    });

    testWidgets('Test 1.6: Multiple rapid theme toggles work correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(MaterialApp));
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      final themeToggleFinder = find.byIcon(Icons.brightness_6);

      // Perform multiple rapid toggles
      for (int i = 0; i < 5; i++) {
        await tester.tap(themeToggleFinder);
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.pumpAndSettle();

      // After 5 toggles (odd number), should be in dark mode
      expect(settingsProvider.isDarkMode, true,
        reason: 'Theme should handle rapid toggles correctly');
      
      print('✓ Test 1.6 PASSED: Multiple rapid theme toggles work correctly');
    });

    test('Test 1.7: SettingsProvider theme state management', () {
      final settingsProvider = SettingsProvider();
      
      // Initial state should be light mode
      expect(settingsProvider.isDarkMode, false);
      
      // Toggle to dark mode
      settingsProvider.toggleTheme();
      expect(settingsProvider.isDarkMode, true);
      
      // Toggle back to light mode
      settingsProvider.toggleTheme();
      expect(settingsProvider.isDarkMode, false);
      
      print('✓ Test 1.7 PASSED: SettingsProvider theme state management works');
    });
  });

  group('Theme Accessibility Tests', () {
    testWidgets('Test 1.8: Theme toggle has semantic label', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Find the theme toggle button
      final themeToggleFinder = find.byIcon(Icons.brightness_6);
      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: themeToggleFinder,
          matching: find.byType(IconButton),
        ),
      );

      // Verify tooltip exists for accessibility
      expect(iconButton.tooltip, isNotNull,
        reason: 'Theme toggle should have a tooltip for accessibility');
      
      print('✓ Test 1.8 PASSED: Theme toggle has accessibility label');
    });
  });
}
