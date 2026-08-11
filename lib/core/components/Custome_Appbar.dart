import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meal_recommendation_b1/core/utiles/assets.dart';

class CustomAppbar extends StatelessWidget {
  final String? leftImage;
  final Widget? leftChild;
  final VoidCallback ontapleft;
  final VoidCallback ontapright;
  final double? leftPadding;
  final double? rightPadding;
  final Widget? rightChild;
  final Color? leftIconColor;
  final Color? rightIconColor;

  const CustomAppbar({
    super.key,
    this.leftImage,
    this.leftChild,
    required this.ontapleft,
    required this.ontapright,
    this.leftPadding,
    this.rightPadding,
    this.rightChild,
    this.leftIconColor,
    this.rightIconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLeftWidget(),
        _buildRightWidget(),
      ],
    );
  }

  Widget _buildLeftWidget() {
    return InkWell(
      onTap: ontapleft,
      child: Container(
        margin: EdgeInsets.only(left: leftPadding ?? 6),
        alignment: Alignment.topLeft,
        child: _determineLeftContent(),
      ),
    );
  }

  Widget _determineLeftContent() {
    if (leftChild != null) {
      return leftChild!;
    }

    if (leftImage != null) {
      return Image.asset(
        leftImage!,
        color: leftIconColor,
      );
    }

    // Default fallback
    return Icon(
      Icons.menu,
      color: leftIconColor ?? Colors.black,
    );
  }

  Widget _buildRightWidget() {
    return InkWell(
      onTap: ontapright,
      child: Container(
        margin: EdgeInsets.only(right: rightPadding ?? 6),
        alignment: Alignment.topRight,
        child: _determineRightContent(),
      ),
    );
  }

  Widget _determineRightContent() {
    if (rightChild != null) {
      return rightChild!;
    }

    // Default fallback
    return SvgPicture.asset(
      Assets.geminiSVG,
      width: 50.0,
      height: 40.0,
      color: rightIconColor,
    );
  }
}