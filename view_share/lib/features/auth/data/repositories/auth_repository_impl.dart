import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:view_share/core/error/failures.dart';
import 'package:view_share/core/network/connection_checker.dart';

import 'package:view_share/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:view_share/core/entities/user.dart';
import 'package:view_share/features/auth/data/models/user_model.dart';
import 'package:view_share/features/auth/domain/repository/auth_repository.dart';

import 'package:view_share/core/error/expceptions.dart';

class AuthReposutoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  AuthReposutoryImpl(
      {required this.remoteDataSource, required this.connectionChecker});

  @override
  Future<Either<Failure, User>> loginWithEmailPassword(
      {required String email, required String password}) async {
    return _getUserFunction(() async => await remoteDataSource
        .loginWithEmailPassword(email: email, password: password));
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return _getUserFunction(() async => await remoteDataSource
        .signUpWithEmailPassword(name: name, email: email, password: password));
  }

  Future<Either<Failure, User>> _getUserFunction(
      Future<User> Function() fn) async {
    try {
      if (!await (connectionChecker.isConnected)) {
        return left(Failure('No internet connection !'));
      }
      final user = await fn();

      return right(user);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      if (!await (connectionChecker.isConnected)) {
        final session = remoteDataSource.currentUserSession;

        if (session == null) {
          return left(Failure('User not logged in !'));
        }
        return right(UserModel(
          id: session.user.id,
          email: session.user.email ?? "",
          name: "test",
        ));
      }
      final user = await remoteDataSource.getCurrentUserData();

      if (user == null) {
        return Left(Failure('User is not logged in ! '));
      }
      return right(user);
    }on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
