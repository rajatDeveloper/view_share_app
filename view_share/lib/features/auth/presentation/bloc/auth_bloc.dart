import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_share/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:view_share/core/usecase/usecase.dart';

import 'package:view_share/core/entities/user.dart';
import 'package:view_share/features/auth/domain/usecases/currenr_user.dart';
import 'package:view_share/features/auth/domain/usecases/user_login.dart';
import 'package:view_share/features/auth/domain/usecases/user_sign_up.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;

  AuthBloc(
      {required UserSignUp userSignUp,
      required UserLogin userLogin,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit})
      : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    //we need to run usecase here

    on<AuthEvent>((_, emit) {
      emit(AuthLoading());
    });

    on<AuthSignUp>(
      _onAuthSignUp,
    );

    on<AuthLogin>(
      _onAuthLogin,
    );

    on<AuthIsUserLoggedIn>(
      _onAuthIsUserLoggedIn,
    );

    on<AuthLogout>(
      _onAuthLogout,
    );
  }

  void _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) async {
    //L is failer and r is success type it is success
    _appUserCubit.updateUser(null);

    emit(AuthNormal());
  }

  void _onAuthIsUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParms());
    //L is failer and r is success type it is success

    res.fold((failure) => emit(AuthFailure(message: failure.message)), (user) {
      print(user.email + "I am here user name ");
      return _emitAuthSuccess(user, emit);
    });
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    final res = await _userLogin(UserLoginParmas(
      email: event.email,
      password: event.password,
    ));
    //L is failer and r is success type it is success

    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(
      UserSignUpParmas(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    //L is failer and r is success type it is success

    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
