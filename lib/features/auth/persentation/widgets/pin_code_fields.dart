import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

Widget buildPinCodeFields(BuildContext context, String code) {
  return PinCodeTextField(
    length: 6,
    autoFocus: true,
    cursorColor: AppColors.black,
    keyboardType: TextInputType.number,
    obscureText: false,
    animationType: AnimationType.scale,
    pinTheme: PinTheme(
      shape: PinCodeFieldShape.box,
      borderRadius: BorderRadius.circular(6.r),
      fieldHeight: 50.h,
      fieldWidth: 50.w,
      activeFillColor: AppColors.white,
      borderWidth: 1,
      activeColor: AppColors.gray,
      inactiveFillColor: AppColors.white,
      inactiveColor: AppColors.selected,
      selectedColor: AppColors.white,
      selectedFillColor: AppColors.white,
    ),
    animationDuration: const Duration(milliseconds: 300),
    backgroundColor: AppColors.primary,
    enableActiveFill: true,
    textStyle: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.bold),
    onCompleted: (code) {
      code = code;
      print("Completed");
    }, appContext: context, onChanged: (String value) { },
  );
}