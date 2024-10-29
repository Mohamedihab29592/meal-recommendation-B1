<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_recommendation_b1/core/utiles/Assets.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
=======
import 'dart:math';
>>>>>>> origin/main

import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller for 2 seconds
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Scaling animation
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Rotation animation (0 to 360 degrees)
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation
    _controller.forward();

    // Navigate after the animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateAfterDelay();
      }
    });
  }

<<<<<<< HEAD
  void _navigateAfterSplash() async {
    final authRepository = getIt<AuthRepository>();
    final user = await authRepository.getSavedUser();

    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    if (user != null) {
      // User is logged in
      context.replaceWith(AppRoutes.home);
    } else {
      // User is not logged in
      context.replaceWith(AppRoutes.login);
=======
  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
>>>>>>> origin/main
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1226),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotateAnimation.value,
                  child: child,
                ),
              ),
            );
          },
          child: Image.asset(
            'assets/images/splash_logo.png',
            width: 120,
            height: 120,
          ),
        ),
      ),
    );
  }
}

