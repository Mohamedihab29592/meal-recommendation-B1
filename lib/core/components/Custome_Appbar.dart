import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppbar extends StatelessWidget {

  final String? leftImage;
  final String? rightImage;
  final VoidCallback ontapleft;
  final VoidCallback ontapright;
  final double? leftPadding ;
  final double? rightPadding ;
  const CustomAppbar(
      {super.key,
      this.rightImage,
      this.leftImage,
      required this.ontapleft,
      required this.ontapright, this.leftPadding, this.rightPadding});


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
              child: SvgPicture.asset(
                "assets/images/gemini.svg",
                width: 50.0,
                height: 40.0,
              ),
            )),
      ],
    );
  }
}
