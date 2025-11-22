import '../../../data/models/auth_response_model.dart';
import '../../repositaries_interfaces/auth_repo_interface.dart';

class LoginUseCase {
  final AuthRepositoryInterface repository;

  LoginUseCase({required this.repository});

  // This special method allows the class to be CALLED like a function
  // So, instead of: loginUseCase.call(event.email, event.password);
  // We can do this:
  Future<AuthResponse> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
