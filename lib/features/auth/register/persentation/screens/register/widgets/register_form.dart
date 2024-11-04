import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/components/custom_text_field.dart';
import 'package:meal_recommendation_b1/core/services/form_input_validation.dart';
import 'package:meal_recommendation_b1/core/utiles/Assets.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.nameTextEditingController,
    required this.emailTextEditingController,
    required this.mobileTextEditingController,
    required this.createPasswordTextEditingController,
    required this.confirmPasswordTextEditingController,
  });
  final TextEditingController nameTextEditingController;

  final TextEditingController emailTextEditingController;

  final TextEditingController mobileTextEditingController;

  final TextEditingController createPasswordTextEditingController;

  final TextEditingController confirmPasswordTextEditingController;
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          hintText: "Full name",
          inputType: TextInputType.name,
          prefixIcon: Assets.icAccount,
          validator: FormInputValidation.emptyValueValidation,
          controller: widget.nameTextEditingController,
        ),
        const SizedBox(height: 22),
        CustomTextField(
          hintText: "Email address",
          inputType: TextInputType.emailAddress,
          prefixIcon: Assets.icMail,
          validator: FormInputValidation.emailValidation,
          controller: widget.emailTextEditingController,
        ),
        const SizedBox(height: 22),
        CustomTextField(
          hintText: "Mobile number",
          validator: FormInputValidation.phoneNumberValidation,
          inputType: TextInputType.phone,
          prefixIcon: Assets.icPhone,
          controller: widget.mobileTextEditingController,
        ),
        const SizedBox(height: 22),
        CustomTextField(
          hintText: "Create password",
          inputType: TextInputType.visiblePassword,
          prefixIcon: Assets.icLock,
          validator: FormInputValidation.passwordValidation,
          controller: widget.createPasswordTextEditingController,
          isPassword: true,
        ),
        const SizedBox(height: 22),
        CustomTextField(
          hintText: "Confirm password",
          validator: FormInputValidation.emptyValueValidation,
          inputType: TextInputType.visiblePassword,
          prefixIcon: Assets.icLock,
          controller: widget.confirmPasswordTextEditingController,
          isPassword: true,
        ),
      ],
    );
  }
}
