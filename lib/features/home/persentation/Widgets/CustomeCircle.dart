import 'package:flutter/material.dart';

import '../../../../core/utiles/app_colors.dart';

class CustomeCircle extends StatelessWidget {
   CustomeCircle({super.key,this.unit,this.amount,this.nutrationName});
  String? amount,nutrationName,unit;
  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment: Alignment.center,
      width: 100,
      height: 120,
      decoration: BoxDecoration(
          border:   Border.all(width: 4,color: AppColors.black),
          shape: BoxShape.circle),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$amount $unit",style: TextStyle(fontWeight: FontWeight.bold,),),
          Text("$nutrationName",style: TextStyle(fontWeight: FontWeight.w500),),
        ],
      ),
    );
  }
}