import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:password_manager_app/main.dart' as app;

// Mock HTTP implementation to avoid external dependencies
class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => MockHttpClient();
}

class MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async => MockHttpClientRequest(url, method);

  @override
  set badCertificateCallback(bool Function(X509Certificate cert, String host, int port)? callback) {}
  
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockHttpClientRequest implements HttpClientRequest {
  final String method;
  @override
  final Uri url;
  @override
  final HttpHeaders headers = MockHttpHeaders();

  MockHttpClientRequest(this.url, this.method);

  @override
  void add(List<int> data) {}

  @override
  Future<HttpClientResponse> close() async => MockHttpClientResponse(url, method);

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  final Uri url;
  final String method;
  @override
  final HttpHeaders headers = MockHttpHeaders();

  MockHttpClientResponse(this.url, this.method);

  @override
  int get statusCode => 200;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    String body = '{}';
    if (url.path.contains('/auth_salt/')) {
      body = jsonEncode({'salt': '00112233445566778899aabbccddeeff'});
    } else if (url.path == '/login') {
      body = jsonEncode({'token': 'mock_token'});
    } else if (url.path.contains('/mfa/status/')) {
      body = jsonEncode({'mfa_enabled': false});
    } else if (url.path == '/vault') {
      body = jsonEncode({'blob': null});
    } else if (url.path == '/vault' && method == 'POST') {
      body = jsonEncode({'ok': true});
    } else if (url.path == '/backups' && method == 'GET') {
      body = jsonEncode({'backups': []});
    } else if (url.path == '/backups' && method == 'POST') {
      body = jsonEncode({'filename': 'backup_testuser_20260310.enc'});
    } else if (url.path == '/logs') {
      body = jsonEncode({'logs': []});
    }
    return Stream.fromIterable([utf8.encode(body)]).listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class MockHttpHeaders implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MockHttpOverrides();

  group('App Integration Tests', () {
    testWidgets('verify login logic and vault landing', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Start Page
      expect(find.text('Login'), findsOneWidget);
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Login Page landing
      final fields = find.byType(TextField);
      await tester.enterText(fields.first, 'testuser');
      await tester.enterText(fields.last, 'password123');
      await tester.tap(find.text('Login'));
      
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify Vault Landing
      expect(find.text('Your Vault'), findsOneWidget);
    });

    testWidgets('verify vault lifecycle: add and delete item', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login bypass (simulated landing)
      final fields = find.byType(TextField);
      await tester.enterText(fields.first, 'testuser');
      await tester.enterText(fields.last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Add Item
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.text('Add Item'), findsOneWidget);
      await tester.enterText(find.widgetWithText(TextField, 'Title'), 'SocialBank');
      await tester.enterText(find.widgetWithText(TextField, 'Password'), 'ComplexPass!123');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      // Verify added item
      expect(find.text('SocialBank'), findsOneWidget);

      // Delete Item
      await tester.tap(find.byIcon(Icons.delete).first);
      await tester.pumpAndSettle();

      expect(find.text('SocialBank'), findsNothing);
    });

    testWidgets('verify backup flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Login
      final fields = find.byType(TextField);
      await tester.enterText(fields.first, 'testuser');
      await tester.enterText(fields.last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Open Backup Dialog
      await tester.tap(find.byIcon(Icons.backup));
      await tester.pumpAndSettle();

      expect(find.text('Encrypted Backups'), findsOneWidget);

      // Create Backup
      await tester.tap(find.text('Create New Backup'));
      await tester.pumpAndSettle();

      // Verify success snackbar (finding by text)
      expect(find.text('Backup created successfully'), findsOneWidget);
    });

    testWidgets('verify register navigation', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Choose a unique username'), findsOneWidget);
    });
  });
}
