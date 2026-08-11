import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/save_recipe_button.dart';

import '../../../../core/services/di.dart';
import '../../../home/persentation/Cubits/AddRecipesCubit/add_ingredient_cubit.dart';
import '../../data/Recipe.dart';
import 'add_ingredients_button.dart';

class RecipeActionButtons extends StatelessWidget {
  final Recipe recipe;
  final bool isSaved;

  const RecipeActionButtons({
    super.key,
    required this.recipe,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocProvider(
                create: (context) => getIt<AddIngredientCubit>(),
                child: AddIngredientsButton(
                  recipe: recipe,
                ),
              ),
              if (!isSaved) const SizedBox(width: 16),
              if (!isSaved) SaveRecipeButton(recipe: recipe),
            ],
          );
        },
      ),
    );
  }
}
