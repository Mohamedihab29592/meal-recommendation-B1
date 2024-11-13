import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import '../utiles/assets.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? prefixIcon;
  final bool isPassword;
  final TextInputType inputType;
  final TextEditingController controller;
  final String? errorText;
  final Function(String)? onChanged;
  final String? Function(String? value) validator;

  const CustomTextField({
    super.key,
    required this.hintText,
     this.prefixIcon,
    this.isPassword = false,
    required this.inputType,
    required this.controller,
    this.errorText,
    this.onChanged,  required this.validator,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          autovalidateMode: AutovalidateMode.onUnfocus,
          validator: widget.validator,
          cursorColor: AppColors.white,
          obscureText: widget.isPassword ? _isObscure : false,
          keyboardType: widget.inputType,
          style: const TextStyle(color: AppColors.white),
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            prefixIcon: SizedBox(
              height: 30.sp,
              width: 30.sp,
              child: Center(
                child: Image.asset(
                  widget.prefixIcon?? Assets.icSplash,
                  height: 30.sp,
                  width: 30.sp,
                  color: Colors.white,
                ),
              ),
            ),
            suffixIcon: widget.isPassword
                ? SizedBox(
                    height: 30.sp,
                    width: 45.sp,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Image(
                          image: AssetImage(
                            _isObscure ? Assets.icEye : Assets.icVisibleOff,
                          ),
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                    ),
                  )

                : null,
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.white),
            errorText: widget.errorText,
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 20.w,
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }
}
