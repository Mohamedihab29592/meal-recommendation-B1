import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';

import '../../../../../../../core/utiles/assets.dart';

class FoodImageBackground extends StatelessWidget {
  const FoodImageBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        image: DecorationImage(
          image: AssetImage(Assets.authLayoutFoodImage),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
