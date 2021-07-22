// ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:meteo_sncf/authentication/authentication.dart';

void main() {
  const emailString = 'email@email.com';
  const emailNotValidString = 'email@email';
  group('Email', () {
    group('constructors', () {
      test('pure creates correct instance', () {
        final email = Email.pure();
        expect(email.value, '');
        expect(email.pure, true);
      });

      test('dirty creates correct instance', () {
        final email = Email.dirty(emailString);
        expect(email.value, emailString);
        expect(email.pure, false);
      });
    });

    group('validator', () {
      test('returns empty error when email is empty', () {
        expect(
          Email.dirty('').error,
          EmailValidationError.empty,
        );
      });
      test('is not valid when email does not match', () {
        expect(
          Email.dirty(emailNotValidString).error,
          EmailValidationError.invalid,
        );
      });
      test('is valid when email is not empty', () {
        expect(
          Email.dirty(emailString).error,
          isNull,
        );
      });
    });
  });
}
