import '../../../data/models/auth_response_model.dart';
import '../../repositaries_interfaces/auth_repo_interface.dart';

class SignUpUseCase {
  final AuthRepositoryInterface repository;

  SignUpUseCase({required this.repository});

  Future<AuthResponse> call(String email, String password, String phone, int gender, String name, String passwordConfirmation) async {
    return await repository.signUp(email, password, phone, gender, name, passwordConfirmation);
  }
}