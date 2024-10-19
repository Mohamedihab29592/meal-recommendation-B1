import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomSmoothPageIndicator extends StatelessWidget {
  final PageController controller;
  final int count;
  final Color activeDotColor;
  final Color dotColor;
  final double dotHeight;
  final double dotWidth;
  final double expansionFactor;

  const CustomSmoothPageIndicator({
    super.key,
    required this.controller,
    required this.count,
    this.activeDotColor = Colors.blueAccent,
    this.dotColor = Colors.grey,
    this.dotHeight = 10.0,
    this.dotWidth = 10.0,
    this.expansionFactor = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: ExpandingDotsEffect(
        activeDotColor: activeDotColor,
        dotColor: dotColor,
        dotHeight: dotHeight,
        dotWidth: dotWidth,
        expansionFactor: expansionFactor,
      ),
    );
  }
}