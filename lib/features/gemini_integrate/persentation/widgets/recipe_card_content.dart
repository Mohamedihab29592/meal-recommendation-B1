import 'package:flutter/cupertino.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/quick_stats_row.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/recipe_action_buttons.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/recipe_header.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/recipe_image.dart';

import '../../data/Recipe.dart';

class RecipeCardContent extends StatelessWidget {
  final Recipe recipe;
  final bool isSaved;

  const RecipeCardContent({
    super.key,
    required this.recipe,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RecipeImage(recipe: recipe),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RecipeHeader(recipe: recipe),
              const SizedBox(height: 12),
              QuickStatsRow(recipe: recipe),
              const SizedBox(height: 16),
              RecipeActionButtons(
                recipe: recipe,
                isSaved: isSaved,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
