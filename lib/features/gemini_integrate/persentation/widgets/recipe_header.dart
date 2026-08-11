import 'package:flutter/material.dart';
import '../../../../core/utiles/app_colors.dart';
import '../../data/Recipe.dart';

class RecipeHeader extends StatelessWidget {
  final Recipe recipe;

  const RecipeHeader({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Chip(
          label: Text(
            recipe.typeOfMeal,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppColors.primary,
        ),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              '4.5',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}