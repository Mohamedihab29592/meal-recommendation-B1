import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/quick_stats_row.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/recipe_header.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/recipe_image.dart';
import '../../data/Recipe.dart';
import 'add_ingredients_button.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () => {
              context.pushNamed(AppRoutes.detailsPage,arguments: recipe.id)
            },
            child: Column(
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
                      AddIngredientsButton(recipe: recipe),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






