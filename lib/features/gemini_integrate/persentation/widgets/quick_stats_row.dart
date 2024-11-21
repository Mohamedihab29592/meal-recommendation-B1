import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/quick_state_Item.dart';

import '../../data/Recipe.dart';

class QuickStatsRow extends StatelessWidget {
  final Recipe recipe;

  const QuickStatsRow({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        QuickStatItem(
          icon: Icons.kitchen,
          label: '${recipe.ingredients.length} Ingredients',
          color: Colors.blue,
        ),
        QuickStatItem(
          icon: Icons.timer,
          label: '${recipe.time} min',
          color: Colors.orange,
        ),
        QuickStatItem(
          icon: Icons.local_fire_department,
          label: '${recipe.nutrition.calories} kcal',
          color: Colors.red,
        ),
      ],
    );
  }
}