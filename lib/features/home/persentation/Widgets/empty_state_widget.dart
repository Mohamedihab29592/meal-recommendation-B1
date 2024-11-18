import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final VoidCallback onActionPressed;

  const EmptyStateWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          Text(subtitle),
          ElevatedButton(
            onPressed: onActionPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            child: const Text("Add Recipe" ,style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
