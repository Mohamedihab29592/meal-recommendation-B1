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
                  colors: _kDefaultRainbowColors),
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