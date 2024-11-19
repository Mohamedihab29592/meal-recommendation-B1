import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:meal_recommendation_b1/core/components/custom_button.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'package:meal_recommendation_b1/core/components/custom_text_field.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/core/utiles/assets.dart';
import 'package:meal_recommendation_b1/core/utiles/secure_storage_helper.dart';
import 'package:meal_recommendation_b1/features/Profile/data/Model/UserModel.dart';
import 'package:meal_recommendation_b1/features/Profile/data/dataSource/local/LocalData.dart';
import '../../../data/data_source/local/secure_local_data.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedUserData();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedUserData() async {
    final userData = await SecureStorageLoginHelper.loadUserData();
    setState(() {
      _rememberMe = userData['rememberMe'] == 'true';
      _emailController.text = userData['email'] ?? '';
      _passwordController.text = userData['password'] ?? '';
    });
  }

  Future<void> _saveUserData() async {
    await SecureStorageLoginHelper.saveUserData(
      rememberMe: _rememberMe,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

// login --> email , password --> remember me ()
//  we have user enitity inside it we have uid after login operation
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is Authenticated) {
            // Navigate to the home screen on successful login
            await SecureStorageHelper.setSecuredString('uid', state.user.uid!);

            Navigator.pushReplacementNamed(context, AppRoutes.home);
            Navigator.pushReplacementNamed(context, AppRoutes.navBar);

          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset(Assets.authLayoutFoodImage),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : screenWidth * 0.1,
                    vertical: isMobile ? 40 : screenHeight * 0.1,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(Assets.icSplash),
                        SizedBox(height: screenHeight * 0.05),
                        CustomTextField(
                          hintText: 'User Name',
                          prefixIcon: Assets.icAccount,
                          inputType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (String? value) {},
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomTextField(
                          hintText: 'Password',
                          prefixIcon: Assets.icLock,
                          inputType: TextInputType.text,
                          controller: _passwordController,
                          isPassword: true,
                          validator: (String? value) {},
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                                _saveUserData();
                              },
                              activeColor: Colors.grey,
                              side: const BorderSide(color: AppColors.white),
                              checkColor: Colors.white,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _rememberMe = !_rememberMe;
                                });
                                _saveUserData();
                              },
                              child: const Text(
                                'Remember me and keep me logged in',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        CustomButton(
                          text: 'Login',
                          onPressed: () {
                            final email = _emailController.text;
                            final password = _passwordController.text;
                            BlocProvider.of<AuthBloc>(context).add(
                              LoginWithEmailEvent(email, password),
                            );
                            _saveUserData();
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.navBar);
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Row(
                            children: [
                              Expanded(child: Divider(color: Colors.white)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'or login with',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Expanded(child: Divider(color: Colors.white)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              onPressed: () {
                                // Handle Google login
                                BlocProvider.of<AuthBloc>(context)
                                    .add(LoginWithGoogleEvent());
                              },
                              backgroundColor: AppColors.white,
                              shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Image.asset(
                                Assets.icGoogle,
                                scale: 5,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                              style: TextStyle(color: AppColors.white),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AppRoutes.register);
                              },
                              child: const Text(
                                'Register now',
                                style: TextStyle(color: AppColors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
