import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_recommendation_b1/core/utiles/assets.dart';

class CustomAppbar extends StatelessWidget {

  final String? leftImage;
  final VoidCallback ontapleft;
  final VoidCallback ontapright;
  final double? leftPadding ;
  final double? rightPadding ;
  final Widget? rightChild;
  const CustomAppbar(
      {super.key,
      this.leftImage,
      required this.ontapleft,
      required this.ontapright, this.leftPadding, this.rightPadding, this.rightChild});


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
            onTap: ontapleft,
            child: Container(
                margin:  EdgeInsets.only(left: leftPadding ?? 6),
                alignment: Alignment.topLeft,
                child: Image.asset("$leftImage"))),
        InkWell(
            onTap: ontapright,
            child: Container(
              margin:  EdgeInsets.only(right: rightPadding ?? 6),
              alignment: Alignment.topRight,
              child: rightChild ?? SvgPicture.asset(
                Assets.geminiSVG,
                width: 50.0,
                height: 40.0,
              ),
            )),
      ],
    );
  }
}
