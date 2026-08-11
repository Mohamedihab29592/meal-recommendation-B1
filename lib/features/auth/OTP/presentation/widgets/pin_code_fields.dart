import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../phone_bloc/phone_bloc.dart';
import '../phone_bloc/phone_event.dart';

Widget buildPinCodeFields(BuildContext context, TextEditingController textController) {
  return PinCodeTextField(
    controller: textController,
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
      BlocProvider.of<PhoneAuthBloc>(context)
          .add(SignIn(otpCode: code));
    }, appContext: context, onChanged: (String value) { },
  );
}