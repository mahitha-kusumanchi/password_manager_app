import 'package:flutter_test/flutter_test.dart';
import 'package:password_manager_app/utils/password_generator.dart';

bool _isStrong(String password) {
  final hasLower = RegExp(r'[a-z]').hasMatch(password);
  final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
  final hasNumber = RegExp(r'[0-9]').hasMatch(password);
  final hasSymbol = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);
  return password.length >= 12 &&
      hasLower &&
      hasUpper &&
      hasNumber &&
      hasSymbol;
}

void main() {
  group('PasswordGenerator strong output', () {
    test('default generation yields a strong password within several attempts',
        () {
      var strongFound = false;

      for (var i = 0; i < 10 && !strongFound; i++) {
        final generated = PasswordGenerator.generate();
        if (_isStrong(generated)) {
          strongFound = true;
        }
      }

      expect(strongFound, isTrue,
          reason:
              'Expected at least one strong password in multiple attempts.');
    });

    test('respects disabled character classes', () {
      final password = PasswordGenerator.generate(
        length: 20,
        useLower: false,
        useNumbers: false,
        useSymbols: false,
      );

      expect(password, isNotEmpty);
      expect(password.length, 20);
      expect(password, matches(RegExp(r'^[A-Z]+')));
    });

    test('returns empty string when no character sets enabled', () {
      final password = PasswordGenerator.generate(
        useLower: false,
        useUpper: false,
        useNumbers: false,
        useSymbols: false,
      );

      expect(password, isEmpty);
    });

    test('clamps length less than 1 to 1', () {
      final password = PasswordGenerator.generate(length: 0);

      expect(password.length, 1);
    });

    test('generates only numbers when only numbers enabled', () {
      final password = PasswordGenerator.generate(
        length: 12,
        useLower: false,
        useUpper: false,
        useSymbols: false,
      );

      expect(password, matches(RegExp(r'^[0-9]+')));
    });

    test('generates only symbols when only symbols enabled', () {
      final password = PasswordGenerator.generate(
        length: 12,
        useLower: false,
        useUpper: false,
        useNumbers: false,
      );

      expect(password, matches(RegExp(r'^[!@#\$%^&*(),.?":{}|<>]+')));
    });

    test('generates only lower and upper when numbers and symbols disabled',
        () {
      final password = PasswordGenerator.generate(
        length: 16,
        useNumbers: false,
        useSymbols: false,
      );

      expect(password, matches(RegExp(r'^[A-Za-z]+')));
    });
  });
}
