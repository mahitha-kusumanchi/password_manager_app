import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:password_manager_app/services/auth_service.dart';
import 'dart:convert';

import 'auth_service_test.mocks.dart';

void main() {
  late AuthService authService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    authService = AuthService(client: mockClient);
  });

  group('Cross Platform Synchronization (AuthService)', () {
    test('getVault fetches the latest encrypted vault blob from server', () async {
      const token = 'valid_token';
      final vaultData = {
        'blob': {
          'vault_salt': '1234salt',
          'nonce': '5678nonce',
          'ciphertext': '90abcdef'
        }
      };

      when(mockClient.get(
        Uri.parse('${AuthService.baseUrl}/vault'),
        headers: {'Authorization': token},
      )).thenAnswer((_) async => http.Response(jsonEncode(vaultData), 200));

      final result = await authService.getVault(token);

      expect(result.containsKey('blob'), true);
      expect(result['blob']['vault_salt'], '1234salt');
    });

    test('updateVault successfully pushes encrypted blob to server', () async {
      const token = 'valid_token';
      final encryptedBlob = {
        'vault_salt': '1234salt',
        'nonce': '5678nonce',
        'ciphertext': '90abcdef'
      };

      when(mockClient.post(
        Uri.parse('${AuthService.baseUrl}/vault'),
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode({'ok': true}), 200));

      final result = await authService.updateVault(token, encryptedBlob);

      expect(result, true);

      final capturedCall = verify(mockClient.post(
        Uri.parse('${AuthService.baseUrl}/vault'),
        headers: anyNamed('headers'),
        body: captureAnyNamed('body'),
      )).captured.single as String;

      final bodyJson = jsonDecode(capturedCall);
      expect(bodyJson.containsKey('blob'), true);
      expect(bodyJson['blob']['vault_salt'], '1234salt');
    });

    test('updateVault throws or returns false on failure', () async {
      const token = 'valid_token';
      final encryptedBlob = {
        'vault_salt': 'new_salt'
      };

      when(mockClient.post(
        Uri.parse('${AuthService.baseUrl}/vault'),
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode({'error': 'Server Error'}), 500));

      final result = await authService.updateVault(token, encryptedBlob);
      expect(result, false);
    });

    test('Simulate full sync cycle: fetch, merge/modify, update', () async {
      // 1. Fetch remote vault
      const token = 'valid_token';
      final remoteVaultData = {
        'blob': {
          'vault_salt': 'remote_salt',
          'nonce': 'remote_nonce',
          'ciphertext': 'remote_cipher'
        }
      };

      when(mockClient.get(
        Uri.parse('${AuthService.baseUrl}/vault'),
        headers: {'Authorization': token},
      )).thenAnswer((_) async => http.Response(jsonEncode(remoteVaultData), 200));

      final pulledVault = await authService.getVault(token);
      expect(pulledVault['blob']['vault_salt'], 'remote_salt');

      // 2. Modify vault (simulated locally) then update it
      final newBlob = {
        'vault_salt': 'merged_salt',
        'nonce': 'merged_nonce',
        'ciphertext': 'merged_cipher'
      };

      when(mockClient.post(
        Uri.parse('${AuthService.baseUrl}/vault'),
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode({'ok': true}), 200));

      final pushSuccess = await authService.updateVault(token, newBlob);
      expect(pushSuccess, true);

      // Verify the post had the new merged vault
      final capturedCall = verify(mockClient.post(
        Uri.parse('${AuthService.baseUrl}/vault'),
        headers: anyNamed('headers'),
        body: captureAnyNamed('body'),
      )).captured.single as String;

      final bodyJson = jsonDecode(capturedCall);
      expect(bodyJson['blob']['vault_salt'], 'merged_salt');
    });
  });
}
