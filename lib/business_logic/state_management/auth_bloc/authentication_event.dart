abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String phone;
  final int gender;
  final String name;
  final String passwordConfirmation;

  SignUpEvent({
    required this.email,
    required this.password,
    required this.phone,
    required this.name,
    required this.gender,
    required this.passwordConfirmation,
  });
}