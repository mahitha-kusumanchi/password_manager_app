import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:argon2/argon2.dart';

class AuthService {
  static const String baseUrl = 'https://diaphragmatically-scimitared-oda.ngrok-free.dev';

  /// Derives a key from password and salt using Argon2id
Future<Uint8List> _derive(String password, Uint8List salt) async {
  final argon2 = Argon2BytesGenerator();

  final params = Argon2Parameters(
    Argon2Parameters.ARGON2_id,
    salt,
    version: Argon2Parameters.ARGON2_VERSION_13,
    iterations: 3,
    memoryPowerOf2: 17, // 2^17 KB = 128 MB
    lanes: 4,
  );

  argon2.init(params);

  final passwordBytes = Uint8List.fromList(utf8.encode(password));
  final hash = Uint8List(32);

  argon2.generateBytes(passwordBytes, hash);

  return hash;
}


  /// Get authentication salt for a user, returns null if user doesn't exist
  Future<Uint8List?> getAuthSalt(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth_salt/$username'),
      );

      if (response.statusCode == 404) {
        return null; // User doesn't exist
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final saltHex = data['salt'] as String;
        return _hexToBytes(saltHex);
      }

      throw Exception('Failed to get auth salt: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error getting auth salt: $e');
    }
  }

  /// Register a new user
  Future<void> register(String username, String password) async {
    try {
      // Generate random salt
      final random = Random.secure();
      final salt = Uint8List.fromList(
        List<int>.generate(16, (i) => random.nextInt(256)),
      );

      // Derive verifier
      final verifier = await _derive(password, salt);

      // Send registration request
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'salt': _bytesToHex(salt),
          'verifier': _bytesToHex(verifier),
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Registration failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }

  /// Login with username and password
  Future<String?> login(String username, String password) async {
    try {
      // Get salt
      final salt = await getAuthSalt(username);
      if (salt == null) {
        throw Exception('User not found');
      }

      // Derive verifier
      final verifier = await _derive(password, salt);

      // Send login request
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'verifier': _bytesToHex(verifier),
        }),
      );

      if (response.statusCode != 200) {
        return null; // Login failed
      }

      final data = json.decode(response.body);
      return data['token'] as String;
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  /// Fetch vault data
  Future<Map<String, dynamic>> getVault(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vault'),
        headers: {'Authorization': token},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      }

      throw Exception('Failed to fetch vault: ${response.statusCode}');
    } catch (e) {
      throw Exception('Error fetching vault: $e');
    }
  }

  /// Convert bytes to hex string
  String _bytesToHex(Uint8List bytes) {
    return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Convert hex string to bytes
  Uint8List _hexToBytes(String hex) {
    final result = Uint8List(hex.length ~/ 2);
    for (var i = 0; i < result.length; i++) {
      result[i] = int.parse(hex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return result;
  }
}