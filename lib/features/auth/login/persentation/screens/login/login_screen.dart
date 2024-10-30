import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Import Flutter Secure Storage
import 'package:meal_recommendation_b1/core/components/custom_button.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import '../../../../../../core/components/custom_text_field.dart';
import '../../../../../../core/utiles/app_colors.dart';
import '../../../../../../core/utiles/assets.dart';
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

  // Initialize Flutter Secure Storage
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

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

  // Load saved email and password
  Future<void> _loadSavedUserData() async {
    final rememberMeValue = await _secureStorage.read(key: 'remember_me');
    if (rememberMeValue == 'true') {
      setState(() {
        _rememberMe = true;
      });
      _emailController.text = await _secureStorage.read(key: 'email') ?? '';
      _passwordController.text = await _secureStorage.read(key: 'password') ?? '';
    }
  }

  Future<void> _saveUserData() async {
    if (_rememberMe) {
      await _secureStorage.write(key: 'remember_me', value: 'true');
      await _secureStorage.write(key: 'email', value: _emailController.text);
      await _secureStorage.write(key: 'password', value: _passwordController.text);
    } else {
      await _secureStorage.write(key: 'remember_me', value: 'false');
      await _secureStorage.delete(key: 'email');
      await _secureStorage.delete(key: 'password');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Navigate to the home screen on successful login
            Navigator.pushReplacementNamed(context, AppRoutes.home);
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
                          prefixIcon: CupertinoIcons.person,
                          inputType: TextInputType.emailAddress,
                          controller: _emailController,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        CustomTextField(
                          hintText: 'Password',
                          prefixIcon: Icons.lock_outline_rounded,
                          inputType: TextInputType.text,
                          controller: _passwordController,
                          isPassword: true,
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
                                BlocProvider.of<AuthBloc>(context).add(LoginWithGoogleEvent());
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
                                Navigator.pushNamed(context, AppRoutes.register);
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
