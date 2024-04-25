import 'package:fpdart/src/either.dart';
import 'package:view_share/core/error/failures.dart';
import 'package:view_share/core/usecase/usecase.dart';
import 'package:view_share/core/entities/user.dart';
import 'package:view_share/features/auth/domain/repository/auth_repository.dart';

class CurrentUser implements UseCase<User, NoParms> {
  final AuthRepository authRepository;

  const CurrentUser({required this.authRepository});

  @override
  Future<Either<Failure, User>> call(NoParms params) async {
    return await authRepository.currentUser();
  }
}
