import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    super.key,
    required this.hint,
    required this.onSaved,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    required this.validator,
    this.controller,
  });
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?) onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      showCursor: true,
      enableInteractiveSelection: false,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      onSaved: onSaved,
      cursorColor: Colors.grey,
      style: Theme.of(context)
          .textTheme
          .titleLarge!
          .copyWith(color: AppColors.primary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: AppColors.primary),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 19),
        enabledBorder: buildBorder(),
        focusedBorder: buildBorder(),
        border: buildBorder(),
      ),
    );
  }

  OutlineInputBorder buildBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xff838383),
      ),
    );
  }
}
