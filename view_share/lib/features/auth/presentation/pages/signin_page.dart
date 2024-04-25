import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_share/core/common/widgets/header.dart';
import 'package:view_share/core/common/widgets/loader.dart';
import 'package:view_share/core/theme/app_color.dart';
import 'package:view_share/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:view_share/features/auth/presentation/pages/signup_page.dart';
import 'package:view_share/features/auth/presentation/widgets/auth_field.dart';
import 'package:view_share/features/auth/presentation/widgets/auth_gradient_btn.dart';
import 'package:view_share/features/blog/presentation/pages/blog_page.dart';
import 'package:view_share/utils/helpfull_functions.dart';

class SignInPage extends StatefulWidget {
  static const String tag = "sign-in";
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showSnackBar(context, state.message);
              } else if (state is AuthSuccess) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  BlogPage.tag,
                  (route) => false,
                );
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Loader();
              }

              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //test
                      Text(
                        'Sign In.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getFontSize(50, getDeviceWidth(context))),
                      ),
                      //fields
                      SizedBox(
                        height: getDeviceHeight(context) * 0.06,
                      ),

                      AuthField(
                          hintText: 'Email', controller: _emailController),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.02,
                      ),
                      AuthField(
                        hintText: 'Password',
                        controller: _passwordController,
                        isObscureText: true,
                      ),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.02,
                      ),
                      //btn
                      AuthGradientButton(
                          buttonText: "Sign-Up",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(AuthLogin(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ));
                            }
                          }),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.01,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignUpPage.tag);
                        },
                        child: RichText(
                          text: TextSpan(
                              text: "Don't have an account?",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                    text: " Sign-Up",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.gradient2))
                              ]),
                        ),
                      ),
                      // const TopWidget(size: 58),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
