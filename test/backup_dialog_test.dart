import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:password_manager_app/services/auth_service.dart';
import 'package:password_manager_app/widgets/backup_dialog.dart';

// Mock AuthService
class MockAuthService extends Fake implements AuthService {
  final List<BackupFile> mockBackups = [
    BackupFile(filename: 'backup1.enc', timestamp: '2023-10-27T10:00:00Z', size: 1024),
    BackupFile(filename: 'backup2.enc', timestamp: '2023-10-28T11:00:00Z', size: 2048),
  ];

  @override
  Future<List<BackupFile>> getBackups(String token) async {
    await Future.delayed(const Duration(milliseconds: 10));
    return mockBackups;
  }

  @override
  Future<String> createBackup(String token) async {
    await Future.delayed(const Duration(milliseconds: 10));
    final newBackup = BackupFile(
        filename: 'backup_new.enc', 
        timestamp: DateTime.now().toIso8601String(), 
        size: 512
    );
    mockBackups.add(newBackup);
    return newBackup.filename;
  }

  @override
  Future<void> restoreBackup(String token, String filename) async {
     await Future.delayed(const Duration(milliseconds: 10));
  }

  @override
  Future<void> deleteBackup(String token, String filename) async {
    await Future.delayed(const Duration(milliseconds: 10));
    mockBackups.removeWhere((b) => b.filename == filename);
  }
}

void main() {
  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<void> openDialog(WidgetTester tester, AuthService authService) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              showDialog(
                context: context, 
                builder: (_) => BackupManagerDialog(
                  token: 'dummy_token',
                  authService: authService,
                ),
              );
            },
            child: const Text('Open Dialog'),
          ),
        ),
      ),
    ));

    // Open the dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pump(); // Start animation
    await tester.pumpAndSettle(); // Finish animation and load data
  }

  testWidgets('BackupManagerDialog shows backups and allows creation', (WidgetTester tester) async {
    // Set screen size
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    tester.binding.window.physicalSizeTestValue = const Size(1280, 1024);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

    final mockAuthService = MockAuthService();
    await openDialog(tester, mockAuthService);

    // Check if backups are displayed
    expect(find.text('backup1.enc'), findsOneWidget);
    expect(find.text('backup2.enc'), findsOneWidget);
    
    // Verify timestamp formatting (partial match)
    expect(find.textContaining('Oct 27, 2023'), findsWidgets);

    // Create new backup
    final createButton = find.text('Create New Backup');
    expect(createButton, findsOneWidget);

    await tester.tap(createButton);
    await tester.pump(); // Start loading
    await tester.pumpAndSettle(); // Finish loading

    // Verify snackbar
    expect(find.text('Backup created successfully'), findsOneWidget);

    // Verify new backup in list
    expect(find.text('backup_new.enc'), findsOneWidget);
  });

   testWidgets('BackupManagerDialog restores backup', (WidgetTester tester) async {
    // Set screen size
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    tester.binding.window.physicalSizeTestValue = const Size(1280, 1024);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

    final mockAuthService = MockAuthService();
    await openDialog(tester, mockAuthService);

    // Find custom Restore button (ElevatedButton)
    final restoreButtons = find.widgetWithText(ElevatedButton, 'Restore');
    expect(restoreButtons, findsWidgets);

    // Tap the first one
     await tester.tap(restoreButtons.first);
     await tester.pumpAndSettle();

     // Verify confirmation dialog
     expect(find.text('Confirm Restore'), findsOneWidget);
     
     // Tap Confirm
     await tester.tap(find.text('RESTORE'));
     await tester.pumpAndSettle();

     // Verify snackbar
     expect(find.text('Backup restored successfully'), findsOneWidget);

     // Verify dialog closed - we check if 'Open Dialog' button is reachable/visible 
     // and backup list is gone.
     expect(find.text('backup1.enc'), findsNothing);
  });

  testWidgets('BackupManagerDialog deletes backup', (WidgetTester tester) async {
    // Set screen size
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    tester.binding.window.physicalSizeTestValue = const Size(1280, 1024);
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    addTearDown(tester.binding.window.clearDevicePixelRatioTestValue);

    final mockAuthService = MockAuthService();
    await openDialog(tester, mockAuthService);

    // Find delete button (IconButton with delete icon)
    final deleteButtons = find.widgetWithIcon(IconButton, Icons.delete);
    expect(deleteButtons, findsWidgets);

    // Tap the first one (deleting backup1.enc)
    await tester.tap(deleteButtons.first);
    await tester.pumpAndSettle();

    // Verify confirmation dialog
    expect(find.text('Delete Backup'), findsOneWidget);
    expect(find.textContaining('Are you sure you want to delete'), findsOneWidget);

    // Tap Delete
    await tester.tap(find.text('Delete'));
    await tester.pump(); // Start loading
    await tester.pumpAndSettle(); // Finish loading

    // Verify snackbar
    expect(find.text('Backup deleted successfully'), findsOneWidget);

    // Verify backup1.enc is gone
    expect(find.text('backup1.enc'), findsNothing);
    
    // Verify backup2.enc is still there
    expect(find.text('backup2.enc'), findsOneWidget);
  });
}
