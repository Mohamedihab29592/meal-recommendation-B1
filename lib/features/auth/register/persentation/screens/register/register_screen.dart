import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/components/my_loading_dialog.dart';
import 'package:meal_recommendation_b1/core/components/show_message.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/auth/OTP/presentation/phone_bloc/phone_bloc.dart';
import 'package:meal_recommendation_b1/features/auth/OTP/presentation/widgets/my_loading_dialog.dart';
import 'package:meal_recommendation_b1/features/auth/register/persentation/bloc/register_bloc.dart';
import 'package:meal_recommendation_b1/features/auth/register/persentation/screens/register/widgets/food_image_background.dart';
import 'package:meal_recommendation_b1/features/auth/register/persentation/screens/register/widgets/register_screen_body.dart';

import '../../../../OTP/presentation/phone_bloc/phone_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          const FoodImageBackground(),
          BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) async {
              if (state is RegisterLoadingState) {
                // loading
                MyLoadingDialog.show(context);
              } else if (state is RegisterErrorState) {
                // error occured
                MyLoadingDialog.hide(context);
                ShowMessage.show(context, state.message);
              } else if (state is RegisterAuthenticatedState ||
                  state is RegisterUnauthenticatedState) {
                // authenticated becaise user made login after registration
                MyLoadingDialog.hide(context);
                context.pushReplacementNamed(AppRoutes.home);
              }
            },
            child: BlocListener<PhoneAuthBloc,PhoneAuthState>(
              listener: (context, state) {
                if(state is Loading){
                  MyLoadingOTPDialog.show(context);
                }else if (state is ErrorOccurred){
                  MyLoadingDialog.hide(context);
                  MyLoadingOTPDialog.showError(context, state.errorMsg);
                }else if (state is PhoneNumberSubmitted){
                  MyLoadingDialog.hide(context);
                  //context.pushReplacementNamed(AppRoutes.home);
                }
              },
              child: const RegisterScreenBody(),
            ),
          ),
        ],
      ),
    );
  }
}
