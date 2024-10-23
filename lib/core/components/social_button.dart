import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialButton extends StatelessWidget {
  final String logo;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  const SocialButton({
    super.key,
    required this.logo,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: const CircleBorder(),
        padding: EdgeInsets.symmetric(vertical: 14.h),
      ),
      child: Image.asset(logo, width: 32.w),
    );
  }
}
