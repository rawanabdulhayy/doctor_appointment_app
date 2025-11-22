import '../../data/models/auth_response_model.dart';

abstract class AuthRepositoryInterface {
  Future<AuthResponse> login(String email, String password);
  Future<AuthResponse> signUp(String email, String password, String phone, int gender, String name, String passwordConfirmation);
}