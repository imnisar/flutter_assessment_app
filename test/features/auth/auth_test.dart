import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_assessment_app/features/auth/presentation/providers/auth_provider.dart';

void main() {
  group('SignupFormState Validation', () {
    test('Email validation correctly identifies valid/invalid emails', () {
      const state = SignupFormState(email: 'test@example.com');
      expect(state.isEmailValid, true);

      const invalidState = SignupFormState(email: 'invalid-email');
      expect(invalidState.isEmailValid, false);
    });

    test('Username validation correctly identifies non-empty usernames', () {
      const state = SignupFormState(username: 'user123');
      expect(state.isUsernameValid, true);

      const emptyState = SignupFormState(username: '');
      expect(emptyState.isUsernameValid, false);
    });

    test('Birthday validation enforces strict DD/MM/YYYY format', () {
      // Valid
      expect(const SignupFormState(birthday: '23/01/2005').isBirthdayValid, true);
      
      // Invalid formats
      expect(const SignupFormState(birthday: '01/23/2005').isBirthdayValid, false);
      expect(const SignupFormState(birthday: '2005/01/23').isBirthdayValid, false);
      expect(const SignupFormState(birthday: '23-01-2005').isBirthdayValid, false);
      expect(const SignupFormState(birthday: '23.01.2005').isBirthdayValid, false);
      
      // Invalid values
      expect(const SignupFormState(birthday: '32/01/2005').isBirthdayValid, false);
      expect(const SignupFormState(birthday: '01/13/2005').isBirthdayValid, false);
      expect(const SignupFormState(birthday: '01/01/1899').isBirthdayValid, false);
    });

    test('Password validation enforces complexity rules', () {
      // Valid
      expect(const SignupFormState(password: 'Password123!').isPasswordValid, true);
      
      // Too short
      expect(const SignupFormState(password: 'Pass1!').isPasswordValid, false);
      
      // No number
      expect(const SignupFormState(password: 'Password!').isPasswordValid, false);
      
      // No special character
      expect(const SignupFormState(password: 'Password123').isPasswordValid, false);
    });

    test('isFormValid is true only when all fields are valid', () {
      const validState = SignupFormState(
        email: 'test@example.com',
        username: 'user123',
        birthday: '23/01/2005',
        password: 'Password123!',
      );
      expect(validState.isFormValid, true);

      const invalidState = SignupFormState(
        email: 'test@example.com',
        username: '',
        birthday: '23/01/2005',
        password: 'Password123!',
      );
      expect(invalidState.isFormValid, false);
    });
  });
}
