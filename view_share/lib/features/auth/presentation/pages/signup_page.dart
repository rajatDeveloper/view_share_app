import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_share/core/common/widgets/loader.dart';
import 'package:view_share/core/theme/app_color.dart';
import 'package:view_share/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:view_share/features/auth/presentation/pages/signin_page.dart';
import 'package:view_share/features/auth/presentation/widgets/auth_field.dart';
import 'package:view_share/features/auth/presentation/widgets/auth_gradient_btn.dart';
import 'package:view_share/features/blog/presentation/pages/blog_page.dart';
import 'package:view_share/utils/helpfull_functions.dart';

class SignUpPage extends StatefulWidget {
  static const String tag = "sign-up";
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                        'Sign Up.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: getFontSize(50, getDeviceWidth(context))),
                      ),
                      //fields
                      SizedBox(
                        height: getDeviceHeight(context) * 0.06,
                      ),
                      AuthField(hintText: 'Name', controller: _nameController),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.02,
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
                            print("wroking ");
                            if (_formKey.currentState!.validate()) {
                              //call function from bloc
                              context.read<AuthBloc>().add(AuthSignUp(
                                  email: _emailController.text.trim(),
                                  name: _nameController.text.trim(),
                                  password: _passwordController.text.trim()));
                            }
                          }),
                      SizedBox(
                        height: getDeviceHeight(context) * 0.01,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignInPage.tag);
                        },
                        child: RichText(
                          text: TextSpan(
                              text: "Do have an account?",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                    text: " Sign-In",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.gradient2))
                              ]),
                        ),
                      )
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
