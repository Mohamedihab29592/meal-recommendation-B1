import 'package:flutter/cupertino.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/saved_recipes_toggle_button.dart';

import 'gemini_save_recipes_button.dart';

class RecipeButtons extends StatelessWidget {
  final int recipesCount;
  final bool showSavedRecipes;
  final VoidCallback onSave;
  final VoidCallback onToggleSavedRecipes;

  const RecipeButtons({
    super.key,
    required this.recipesCount,
    required this.showSavedRecipes,
    required this.onSave,
    required this.onToggleSavedRecipes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GeminiSaveRecipesButton(
          onSave: onSave,
          recipesCount: recipesCount,
        ),
        const SizedBox(width: 46),
        SavedRecipesToggleButton(
          showSavedRecipes: showSavedRecipes,
          onToggle: onToggleSavedRecipes,
        ),
      ],
    );
  }
}
