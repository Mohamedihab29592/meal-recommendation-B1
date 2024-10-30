import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/components/profile_button.dart';
import 'package:meal_recommendation_b1/core/services/form_input_validation.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/Screens/widgets/profile_text_field.dart';

class ProfileViewForm extends StatelessWidget {
  const ProfileViewForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ProfileTextField(
            hint: "Name",
            onSaved: (value) {},
            validator: FormInputValidation.emptyValueValidation,
          ),
          const SizedBox(
            height: 22,
          ),
          ProfileTextField(
            hint: "Email",
            onSaved: (value) {},
            validator: FormInputValidation.emptyValueValidation,
          ),
          const SizedBox(
            height: 22,
          ),
          ProfileTextField(
            hint: "Phone",
            onSaved: (value) {},
            validator: FormInputValidation.emptyValueValidation,
          ),
          const SizedBox(
            height: 22,
          ),
          ProfileTextField(
            hint: "Password",
            obscureText: true,
            onSaved: (value) {},
            validator: FormInputValidation.emptyValueValidation,
          ),
          const Expanded(
            child: SizedBox(
              height: 25,
            ),
          ),
          ProfileButton(
            onPressed: () {},
            text: "Save",
          ),
          const Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
