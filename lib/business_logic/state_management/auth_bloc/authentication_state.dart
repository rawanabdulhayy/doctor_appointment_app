import '../../../data/models/auth_response_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final AuthResponse authResponse;

  AuthSuccess({required this.authResponse});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

class AuthShowLogin extends AuthState {
   AuthShowLogin();
}

class AuthShowSignup extends AuthState {
  AuthShowSignup();
}
