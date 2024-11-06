import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';

class ProfileButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ProfileButton({
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
          foregroundColor: Colors.white,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.height *
                    0.012), // Slightly rounded corners
          ),
          padding:
              EdgeInsets.symmetric(vertical: 14.h), // Good vertical padding
          elevation: 2, // Slight elevation for a flat button look
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height *
                0.022, // Font size matching the button size
            fontWeight: FontWeight.w600, // Medium bold for visibility
          ),
        ),
      ),
    );
  }
}
