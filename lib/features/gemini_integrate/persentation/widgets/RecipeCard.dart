import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/utiles/assets.dart';

import '../../data/Recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section with a fallback placeholder
          recipe.imageUrl.isNotEmpty
              ? Image.network(recipe.imageUrl, fit: BoxFit.cover)
              : Image.asset(Assets.icSplash, fit: BoxFit.cover),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe name with improved text styling
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),

                // Recipe description
                Text(
                  recipe.description,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 12),

                // Ingredients section with bold title
                const Text(
                  'Ingredients:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.ingredients.map((ingredient) {
                    return Row(
                      children: [
                        // Ingredient image with a fallback placeholder
                        ingredient.imageUrl.isNotEmpty
                            ? Image.network(ingredient.imageUrl, width: 40, height: 40, fit: BoxFit.cover)
                            : Image.asset(Assets.icSplash, width: 40, height: 40),
                        const SizedBox(width: 8),
                        Text(
                          '${ingredient.quantity} ${ingredient.unit} ${ingredient.name}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Instructions section with bold title
                const Text(
                  'Instructions:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.instructions
                      .map((instruction) => Text('- $instruction', style: const TextStyle(fontSize: 14)))
                      .toList(),
                ),
                const SizedBox(height: 12),

                // Nutrition section with bold title
                const Text(
                  'Nutrition Info:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('Calories: ${recipe.nutrition.calories} kcal'),
                Text('Protein: ${recipe.nutrition.protein} g'),
                Text('Carbs: ${recipe.nutrition.carbs} g'),
                Text('Fat: ${recipe.nutrition.fat} g'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
