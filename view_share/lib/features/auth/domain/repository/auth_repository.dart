import 'package:fpdart/fpdart.dart';
import 'package:view_share/core/error/failures.dart';
import 'package:view_share/core/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name, required String email, required String password});

  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password});

  Future<Either<Failure, User>> currentUser();
}
