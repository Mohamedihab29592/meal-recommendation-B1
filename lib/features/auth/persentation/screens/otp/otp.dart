import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/features/auth/persentation/bloc/phone_bloc/phone_event.dart';

import '../../../../../core/components/custom_button.dart';
import '../../../../../core/utiles/Assets.dart';
import '../../../../../core/utiles/app_colors.dart';
import '../../../../../core/utiles/app_strings.dart';
import '../../bloc/phone_bloc/phone_bloc.dart';
import '../../bloc/phone_bloc/phone_state.dart';
import '../../widgets/my_loading_dialog.dart';
import '../../widgets/pin_code_fields.dart';


class OTPView extends StatefulWidget {
  const OTPView({super.key});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  String phoneNum = "";
  String code = "";

  @override
  void initState() {
    phoneNum = "+2001208820832";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PhoneAuthBloc>(),
      child: BlocConsumer<PhoneAuthBloc,PhoneAuthState>(
        listener: (context,state){
          if(state is Loading){
            MyLoadingDialog.show(context);
          }
          else if(state is ErrorOccurred){
            MyLoadingDialog.hide(context);
          }
        },
        builder: (context,state) {
          return Scaffold(
            backgroundColor: AppColors.primary,
            body: bodyContent(context),
          );
        }
      ),
    );
  }
  Widget bodyContent(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.authLayoutFoodImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 34.h,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h,horizontal: 15.w),
              child: Column(
                children: [
                  Image.asset(Assets.logo),
                  SizedBox(
                    height: 33.h,
                  ),
                  Text(AppStrings.verification, style: TextStyle(fontSize: 26.sp,fontWeight: FontWeight.bold,color: AppColors.white)),
                  SizedBox(
                    height: 26.h,
                  ),
                  Text('${AppStrings.enter4Digits} $phoneNum', style: TextStyle(fontSize: 18.sp,color: AppColors.white),textAlign: TextAlign.center,),
                  SizedBox(
                    height: 55.h,
                  ),
                  buildPinCodeFields(context, code),
                  SizedBox(
                    height: 33.h,
                  ),
                  CustomButton(onPressed: () {
                    BlocProvider.of<PhoneAuthBloc>(context).add(SubmittedPhoneNumber(phoneNumber: '010'));
                    //BlocProvider.of<SignIn>(context).add((phoneNumber: '010'));
                  },text: AppStrings.continueBtn)
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
