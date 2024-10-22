import 'package:flutter/material.dart';
 import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor:  AppColors.primary,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r), // More rounded corners (pill shape)
          ),
          padding: EdgeInsets.symmetric(vertical: 16.h), // Padding for better touch area
          shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow for depth
          elevation: 3, // Slight elevation for a modern look
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.sp, // Adaptive font size for better readability
            fontWeight: FontWeight.w600, // Slightly bolder text for emphasis
          ),
        ),
      ),
    );
  }
}