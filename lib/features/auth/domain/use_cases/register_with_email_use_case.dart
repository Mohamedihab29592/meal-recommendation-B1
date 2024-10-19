import '../repository/auth_repository.dart';

class RegisterWithEmailUseCase {
  final AuthRepository repository;

  RegisterWithEmailUseCase(this.repository);

  Future<void> call({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    return await repository.registerWithEmail(
      name: name,
      email: email,
      phone: phone,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}