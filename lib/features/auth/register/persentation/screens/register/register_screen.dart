import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/components/my_loading_dialog.dart';
import 'package:meal_recommendation_b1/core/components/show_message.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/features/auth/register/persentation/bloc/register_bloc.dart';
import 'package:meal_recommendation_b1/features/auth/register/persentation/screens/register/widgets/food_image_background.dart';
import 'package:meal_recommendation_b1/features/auth/register/persentation/screens/register/widgets/register_screen_body.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<RegisterBloc>(),
        child: Stack(
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
                } else if (state is RegisterAuthenticatedState) {
                  // authenticated becaise user made login after registration
                  MyLoadingDialog.hide(context);

                  ShowMessage.show(context, state.user.name);
                } else if (state is RegisterUnauthenticatedState) {
                  // Unauthenticated so user has to login after registration
                  MyLoadingDialog.hide(context);

                  ShowMessage.show(context,
                      "Your Registration was Successfull , Please Log in now ... ");
                }
              },
              child: const RegisterScreenBody(),
            ),
          ],
        ),
      ),
    );
  }
}
