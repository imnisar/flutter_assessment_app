import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_assessment_app/core/services/auth_service.dart';

class SignupFormState {
  final String email;
  final String username;
  final String birthday;
  final String password;
  final bool isLoading;
  final String? errorMessage;

  const SignupFormState({
    this.email = '',
    this.username = '',
    this.birthday = '',
    this.password = '',
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isEmailValid => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  bool get isUsernameValid => username.isNotEmpty;
  bool get isBirthdayValid {
    if (birthday.length != 10) return false;
    final regex = RegExp(r'^(\d{2})/(\d{2})/(\d{4})$');
    final match = regex.firstMatch(birthday);
    if (match == null) return false;

    final day = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final year = int.tryParse(match.group(3)!);

    if (day == null || month == null || year == null) return false;
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;
    if (year < 1900 || year > 2100) return false;

    return true;
  }
  bool get isPasswordValid {
    if (password.length < 8) return false;
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    return hasLetter && hasNumber && hasSpecial;
  }

  bool get isFormValid => isEmailValid && isUsernameValid && isBirthdayValid && isPasswordValid;

  SignupFormState copyWith({
    String? email,
    String? username,
    String? birthday,
    String? password,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SignupFormState(
      email: email ?? this.email,
      username: username ?? this.username,
      birthday: birthday ?? this.birthday,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class SignupNotifier extends StateNotifier<SignupFormState> {
  final AuthService _authService;
  SignupNotifier(this._authService) : super(const SignupFormState());

  void updateEmail(String val) => state = state.copyWith(email: val);
  void updateUsername(String val) => state = state.copyWith(username: val);
  void updateBirthday(String val) => state = state.copyWith(birthday: val);
  void updatePassword(String val) => state = state.copyWith(password: val);

  Future<bool> signUp() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _authService.signUp(
        email: state.email,
        password: state.password,
        username: state.username,
        birthday: state.birthday,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final signupProvider = StateNotifierProvider<SignupNotifier, SignupFormState>((ref) {
  return SignupNotifier(ref.watch(authServiceProvider));
});
