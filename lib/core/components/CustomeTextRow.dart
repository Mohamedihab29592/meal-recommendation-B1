import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';

import '../utiles/app_colors.dart';

class CustomeTextRow extends StatelessWidget {
   CustomeTextRow({super.key,this.rightText,this.leftText});
  String? leftText;
  String? rightText;
  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$leftText",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        TextButton(onPressed: (){
          Navigator.of(context).pushNamed(AppRoutes.seeAll);
        }, child: Text("$rightText",style: TextStyle(color: AppColors.primary,fontWeight: FontWeight.w600),))
      ],);
  }
}
