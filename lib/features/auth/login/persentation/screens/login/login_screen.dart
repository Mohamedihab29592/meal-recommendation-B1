import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/app_strings.dart';
import '../../../../../../core/components/custom_button.dart';
import '../../../../../../core/components/custom_text_field.dart';
import '../../../../../../core/components/dynamic_notification_widget.dart';
import '../../../../../../core/components/loading_dialog.dart';
import '../../../../../../core/routes/app_routes.dart';
import '../../../../../../core/utiles/app_colors.dart';
import '../../../../../../core/utiles/assets.dart';
import '../../../../../../core/utiles/secure_storage_helper.dart';
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
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize controllers in initState
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Load saved user data
    _loadSavedUserData(_emailController,_passwordController);
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
        listener: (context, state) async {
          if (state is Authenticated) {
            await SecureStorageHelper.setSecuredString(
                AppStrings.uid,
                state.user.id);
             print(state.user.email);
            if (state.isNewUser) {
              Navigator.pushReplacementNamed(context, AppRoutes.welcome);
            } else if (state.isFirstLogin) {
              // Returning user, but first time logging in after registration
              Navigator.pushReplacementNamed(context, AppRoutes.welcome);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.navBar);
            }
          } else if (state is AuthError) {
            String errorMessage = state.errorMessage;

            switch (state.errorType) {
              case AuthErrorType.invalidCredentials:
                errorMessage = 'Invalid email or password';
                break;
              case AuthErrorType.networkError:
                errorMessage = 'No internet connection';
                break;
              case AuthErrorType.userNotFound:
                errorMessage = 'User not found';
                break;
              default:
                errorMessage = 'An unexpected error occurred';
            }

            _showErrorNotification(context, errorMessage);
          } else if (state is Unauthenticated) {
            // Optional: Handle unauthenticated state with a specific message
            _showErrorNotification(
                context, state.errorMessage ?? 'Login failed');
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const LoadingDialog();
          }


          return Stack(
            children: [
              // Background Image
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image.asset(Assets.authLayoutFoodImage),
              ),

              // Login Content
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
                        // App Logo
                        Image.asset(Assets.icSplash),
                        SizedBox(height: screenHeight * 0.05),

                        _buildEmailTextField(_emailController, screenHeight),

                        _buildPasswordTextField(_passwordController, screenHeight),

                        /*RememberMeWidget(
                      emailController: emailController,
                      passwordController: passwordController)*/

                        SizedBox(height: screenHeight * 0.03),

                        _buildLoginButton(
                            context, _emailController, _passwordController),

                        const LoginDividerWidget(),

                        const GoogleLoginButton(),

                        SizedBox(height: screenHeight * 0.02),

                        // Register Option
                        const RegisterOptionWidget(),
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

  Widget _buildEmailTextField(
      TextEditingController emailController, double screenHeight) {
    return Column(
      children: [
        CustomTextField(
          hintText: 'User Name',
          prefixIcon: Assets.icAccount,
          inputType: TextInputType.emailAddress,
          controller: emailController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!_isValidEmail(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  Widget _buildPasswordTextField(
      TextEditingController passwordController, double screenHeight) {
    return Column(
      children: [
        CustomTextField(
          hintText: 'Password',
          prefixIcon: Assets.icLock,
          inputType: TextInputType.text,
          controller: passwordController,
          isPassword: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
        SizedBox(height: screenHeight * 0.02),
      ],
    );
  }

  // Build Login Button
  Widget _buildLoginButton(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) {
    return CustomButton(
      text: 'Login',
      onPressed: () =>
          _performLogin(context, emailController, passwordController),
    );
  }

  // Perform Login
  void _performLogin(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validate inputs
    if (_validateInputs(context, email, password)) {
      // Attempt login
      BlocProvider.of<AuthBloc>(context).add(
        LoginWithEmailEvent(email: email, password: password),
      );
    }
  }

  // Validate Login Inputs
  bool _validateInputs(BuildContext context, String email, String password) {
    if (email.isEmpty) {
      _showErrorNotification(context, 'Please enter your email');
      return false;
    }

    if (!_isValidEmail(email)) {
      _showErrorNotification(context, 'Please enter a valid email');
      return false;
    }

    if (password.isEmpty) {
      _showErrorNotification(context, 'Please enter your password');
      return false;
    }

    if (password.length < 6) {
      _showErrorNotification(context, 'Password must be at least 6 characters');
      return false;
    }

    return true;
  }

  // Email Validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  // Load Saved User Data
  Future<void> _loadSavedUserData(TextEditingController emailController,
      TextEditingController passwordController) async {
    try {
      final userData = await SecureStorageLoginHelper.loadUserData();
      emailController.text = userData['email'] ?? '';
      passwordController.text = userData['password'] ?? '';
    } catch (e) {
      // Handle any potential errors in loading saved data
      print('Error loading saved user data: $e');
    }
  }

  // Show Error Notification
  void _showErrorNotification(BuildContext context, String message) {
    DynamicNotificationWidget.showNotification(
      context: context,
      title: 'Oh Hey!!',
      message: message,
      color: Colors.red,
      contentType: ContentType.failure,
      inMaterialBanner: false,
    );
  }
}

class RememberMeWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RememberMeWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> rememberMeNotifier = ValueNotifier(false);

    return Row(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: rememberMeNotifier,
          builder: (context, rememberMe, child) {
            return Checkbox(
              value: rememberMe,
              onChanged: (value) {
                rememberMeNotifier.value = value!;
                _saveUserData(
                  rememberMe: value,
                  email: emailController.text,
                  password: passwordController.text,
                );
              },
              activeColor: Colors.grey,
              side: const BorderSide(color: AppColors.white),
              checkColor: Colors.white,
            );
          },
        ),
        GestureDetector(
          onTap: () {
            rememberMeNotifier.value = !rememberMeNotifier.value;
            _saveUserData(
              rememberMe: rememberMeNotifier.value,
              email: emailController.text,
              password: passwordController.text,
            );
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
    );
  }

  Future<void> _saveUserData({
    required bool rememberMe,
    required String email,
    required String password,
  }) async {
    await SecureStorageLoginHelper.saveUserData(
      rememberMe: rememberMe,
      email: email,
      password: password,
    );
  }
}

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          onPressed: () {
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
    );
  }
}

class RegisterOptionWidget extends StatelessWidget {
  const RegisterOptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
            style: TextStyle(color: AppColors.white,fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class LoginDividerWidget extends StatelessWidget {
  const LoginDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
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
    );
  }
}
