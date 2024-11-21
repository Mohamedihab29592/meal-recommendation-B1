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
          foregroundColor: AppColors.primary,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45.r),
          ),
          // Padding for better touch area
          shadowColor: Colors.black.withOpacity(0.2), // Subtle shadow for depth
          elevation: 3, // Slight elevation for a modern look
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 21.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
