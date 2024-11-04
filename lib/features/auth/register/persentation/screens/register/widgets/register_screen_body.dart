import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/components/custom_button.dart';
import 'package:meal_recommendation_b1/core/components/show_message.dart';
import 'package:meal_recommendation_b1/core/components/social_button.dart';
import 'package:meal_recommendation_b1/core/utiles/Assets.dart';
import 'package:meal_recommendation_b1/features/auth/register/persentation/bloc/register_bloc.dart';
import 'package:meal_recommendation_b1/features/auth/register/persentation/screens/register/widgets/accepting_terms_check_box.dart';
import 'package:meal_recommendation_b1/features/auth/register/persentation/screens/register/widgets/register_form.dart';

class RegisterScreenBody extends StatefulWidget {
  const RegisterScreenBody({
    super.key,
  });

  @override
  State<RegisterScreenBody> createState() => _RegisterScreenBodyState();
}

class _RegisterScreenBodyState extends State<RegisterScreenBody> {
  final _controller = ScrollController();
  GlobalKey<FormState> formKey = GlobalKey();
  late TextEditingController nameTextEditingController;

  late TextEditingController emailTextEditingController;

  late TextEditingController mobileTextEditingController;

  late TextEditingController createPasswordTextEditingController;

  late TextEditingController confirmPasswordTextEditingController;
  ValueNotifier<bool> acceptingTermsNotifier = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    nameTextEditingController = TextEditingController();
    emailTextEditingController = TextEditingController();
    mobileTextEditingController = TextEditingController();
    createPasswordTextEditingController = TextEditingController();
    confirmPasswordTextEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 76.sp,
              width: 76.sp,
              child: Image.asset(Assets.icSplash),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: FadingEdgeScrollView.fromSingleChildScrollView(
                gradientFractionOnStart: 0.5,
                gradientFractionOnEnd: 0.5,
                child: SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RegisterForm(
                        confirmPasswordTextEditingController:
                            confirmPasswordTextEditingController,
                        createPasswordTextEditingController:
                            createPasswordTextEditingController,
                        emailTextEditingController: emailTextEditingController,
                        mobileTextEditingController:
                            mobileTextEditingController,
                        nameTextEditingController: nameTextEditingController,
                      ),
                      const SizedBox(height: 22),
                      AcceptingTermsCheckBox(
                          acceptingTermsNotifier: acceptingTermsNotifier),
                      const SizedBox(
                        height: 30,
                      ),
                      CustomButton(
                        text: "register",
                        onPressed: () {
                          if (formKey.currentState!.validate() &&
                              acceptingTermsNotifier.value) {
                            BlocProvider.of<RegisterBloc>(context).add(
                              RegisterWithEmailEvent(
                                name: nameTextEditingController.text,
                                password:
                                    createPasswordTextEditingController.text,
                                email: emailTextEditingController.text,
                                phone: mobileTextEditingController.text,
                                confirmPassword:
                                    confirmPasswordTextEditingController.text,
                              ),
                            );
                          } else {
                            ShowMessage.show(
                                context, "You Have To Accept Our Terms ...");
                          }
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(
                            indent: 25,
                          )),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "or login with",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(color: Colors.white),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Expanded(
                            child: Divider(
                              endIndent: 25,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      SocialButton(
                        logo: Assets.icGoogle,
                        onPressed: () {
                          if (acceptingTermsNotifier.value) {
                            BlocProvider.of<RegisterBloc>(context).add(
                              LoginWithGoogleEvent(),
                            );
                          } else {
                            ShowMessage.show(
                                context, "You Have To Accept Our Terms ...");
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
