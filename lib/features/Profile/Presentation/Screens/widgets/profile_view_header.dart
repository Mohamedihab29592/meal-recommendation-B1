import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/utiles/assets.dart';

class ProfileViewHeader extends StatelessWidget {
  const ProfileViewHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(Assets.icProfileMenu),
        const Spacer(),
        Image.asset(Assets.icNotification),
      ],
    );
  }
}
