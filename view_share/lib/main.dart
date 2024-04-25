import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_share/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:view_share/core/theme/theme.dart';
import 'package:view_share/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:view_share/features/auth/presentation/pages/signin_page.dart';
import 'package:view_share/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:view_share/features/blog/presentation/pages/blog_page.dart';
import 'package:view_share/init_import.dart';

import 'package:view_share/utils/router.dart';

//5:42
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => serviceLocator<AppUserCubit>()),
      BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      BlocProvider(create: (_) => serviceLocator<BlogBloc>())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'View Share',
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BlogPage();
          }
          return const SignInPage();
        },
      ),
      routes: getAppRoutes(),
    );
  }
}
