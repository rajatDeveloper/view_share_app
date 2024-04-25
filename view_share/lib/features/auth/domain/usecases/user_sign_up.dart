import 'package:fpdart/src/either.dart';
import 'package:view_share/core/error/failures.dart';
import 'package:view_share/core/usecase/usecase.dart';
import 'package:view_share/core/entities/user.dart';
import 'package:view_share/features/auth/domain/repository/auth_repository.dart';

class UserSignUp implements UseCase<User, UserSignUpParmas> {
  final AuthRepository authRepository;

  const UserSignUp({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(UserSignUpParmas params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParmas {
  final String name;
  final String email;
  final String password;

  UserSignUpParmas(
      {required this.name, required this.email, required this.password});
}
