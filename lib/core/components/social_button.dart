import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButton extends StatelessWidget {
  final String logo;
  final String label;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.logo,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(logo, width: 24.w),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        padding:  EdgeInsets.symmetric(vertical: 14.h),
      ),
    );
  }
}