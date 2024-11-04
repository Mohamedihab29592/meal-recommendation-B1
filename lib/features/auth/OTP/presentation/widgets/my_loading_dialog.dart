import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/core/utiles/app_strings.dart';

class MyLoadingDialog extends StatefulWidget {
  static void show(BuildContext context) =>
      showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => const MyLoadingDialog(),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.of(context).pop();

  static void showError(BuildContext context, String errorMessage) {
    showDialog<void>(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Row(
          children: [
            Icon(Icons.error, color: AppColors.primary, size: 30.w),
            SizedBox(width: 10.w),
            Text(AppStrings.errorTitle,
                style: TextStyle(fontSize: 20.sp, color: AppColors.black)),
          ],
        ),
        content: Text(
          errorMessage,
          style: TextStyle(fontSize: 16.sp, color: AppColors.black),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppStrings.dismiss,
              style: TextStyle(color: AppColors.primary, fontSize: 16.sp),
            ),
          ),
        ],
      ),
    );
  }

  const MyLoadingDialog({super.key});

  @override
  MyLoadingDialogState createState() => MyLoadingDialogState();
}

class MyLoadingDialogState extends State<MyLoadingDialog> {
  final List<Color> _kDefaultRainbowColors = const [
    AppColors.primary,
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 70.h,
              child: LoadingIndicator(
                indicatorType: Indicator.ballSpinFadeLoader,
                colors: _kDefaultRainbowColors,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              AppStrings.pleaseWait,
              style: TextStyle(
                fontSize: 18.sp,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
