import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final double elevation;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.backgroundColor,
    this.elevation = 3.0,
    this.borderRadius = 45.0,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    this.fontSize = 21.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor ?? AppColors.primary,
          backgroundColor: backgroundColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          shadowColor: Colors.black.withOpacity(0.2),
          elevation: elevation,
        ),
        child: Padding(
          padding: padding,
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: textColor ?? AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}