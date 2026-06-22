import 'package:dartz/dartz.dart';
import '../../../../../core/networking/firebase_error_model.dart';
import '../../../login/domain/entity/user_entity.dart';
import '../../data/repository_impl/register_repository_impl.dart';


abstract class RegisterRepository {
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  });

  Future<UserEntity?> loginWithGoogle();

  Future<Either<FirebaseErrorModel, Unit>> addNewUser({
    required UserEntity user
  });
}
