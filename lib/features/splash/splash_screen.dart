import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/utiles/Assets.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';

import '../../core/routes/app_routes.dart';
import '../../core/services/di.dart';
import '../auth/domain/repository/auth_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _jumpAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Define jump animation (moves up and down)
    _jumpAnimation = Tween<double>(begin: 0.0, end: -20.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_animationController);

    // Define scale animation (grows and shrinks)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_animationController);

    // Define rotation animation (spins 180 degrees)
    _rotateAnimation = Tween<double>(begin: 0.0, end: 6.28270) // Half rotation
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_animationController);

    // Define fade animation (fade in and out)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_animationController);

    // Start the animation
    _animationController.forward();

    // Navigate to the next screen after a delay
    _navigateAfterSplash();
  }

  void _navigateAfterSplash() async {
    final authRepository = getIt<AuthRepository>();
    final user = await authRepository.getSavedUser();

    await Future.delayed(const Duration(seconds: 4)); // Splash delay

    if (user != null) {
      // User is logged in
      context.replaceWith(AppRoutes.home);
    } else {
      // User is not logged in
      context.replaceWith(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1226), // Navy blue background
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation, // Fade effect
              child: Transform.translate(
                offset: Offset(0, _jumpAnimation.value), // Jump up and down
                child: Transform.rotate(
                  angle: _rotateAnimation.value, // Rotate the icon
                  child: Transform.scale(
                    scale: _scaleAnimation.value, // Scale up and down
                    child: SizedBox(
                      width: 120.w,
                      height: 120.h,
                      child: Image.asset(Assets.icSplash),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
