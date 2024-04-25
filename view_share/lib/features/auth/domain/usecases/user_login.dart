import 'package:fpdart/fpdart.dart';
import 'package:view_share/core/error/failures.dart';
import 'package:view_share/core/usecase/usecase.dart';
import 'package:view_share/core/entities/user.dart';
import 'package:view_share/features/auth/domain/repository/auth_repository.dart';

class UserLogin implements UseCase<User, UserLoginParmas> {
  final AuthRepository _authRepository;

  const UserLogin({required AuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, User>> call(UserLoginParmas params) async {
    return await _authRepository.loginWithEmailPassword(
        email: params.email, password: params.password);
  }
}

class UserLoginParmas {
  final String email;
  final String password;

  UserLoginParmas({required this.email, required this.password});
}
