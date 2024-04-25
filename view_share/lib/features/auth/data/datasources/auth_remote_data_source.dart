import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:view_share/core/error/expceptions.dart';
import 'package:view_share/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword(
      {required String name, required String email, required String password});

  Future<UserModel> loginWithEmailPassword(
      {required String email, required String password});

  Session? get currentUserSession;

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImp implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImp({required this.supabaseClient});

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth
          .signInWithPassword(email: email, password: password);

      if (response.user == null) {
        throw const ServerException('User is null');
      }

      print(response.user!.toJson());

      return UserModel(
        email: response.user!.email!,
        id: response.user!.id,
        name: response.user!.userMetadata!['name'],
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth
          .signUp(data: {'name': name}, email: email, password: password);
      print(response.user!.toJson());
      if (response.user == null) {
        throw const ServerException('User is null');
      }
      return UserModel(
        email: response.user!.email!,
        id: response.user!.id,
        name: response.user!.userMetadata!['name'],
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);

        return UserModel(
          email: currentUserSession!.user.email!,
          id: currentUserSession!.user.id,
          name: userData.first['name'],
        );
      }

      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
