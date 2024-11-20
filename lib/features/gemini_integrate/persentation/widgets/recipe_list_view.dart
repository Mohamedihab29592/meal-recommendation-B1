import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/recipe_empty_state.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/recipe_error_view.dart';

import '../../../home/persentation/Cubits/AddRecipesCubit/add_ingredient_cubit.dart';
import '../../data/Recipe.dart';
import '../bloc/RecipeBloc.dart';
import '../bloc/RecipeEvent.dart';
import '../bloc/RecipeState.dart';
import 'RecipeCard.dart';
import 'loading_chat_widget.dart';

class RecipeListView extends StatelessWidget {
  final RecipeState state;
  final bool showSavedRecipes;

  const RecipeListView({
    super.key,
    required this.state,
    required this.showSavedRecipes,
  });

  @override
  Widget build(BuildContext context) {
    if (state is RecipeLoading) {
      return const LoadingChatWidget();
    } else if (state is RecipeLoaded || state is SavedRecipesLoaded) {
      final List<Recipe> recipes = state is RecipeLoaded
          ? (state as RecipeLoaded).recipes
          : (state as SavedRecipesLoaded).savedRecipes;

      if (recipes.isEmpty) {
        return RecipeEmptyState(showSavedRecipes: showSavedRecipes);
      }

      return ListView.builder(
        itemCount: recipes.length,
        padding: const EdgeInsets.only(bottom: 16),
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          context.read<AddIngredientCubit>().checkIngredientsAdded(recipe);
          return RecipeCard(
            recipe: recipe,
            isSaved: showSavedRecipes || state is SavedRecipesLoaded,
          );

        },
      );
    } else if (state is RecipeError) {
      return RecipeErrorView(
        errorMessage: (state as RecipeError).message,
        onRetry: () => context.read<RecipeBloc>().add(LoadSavedRecipesEvent()),
      );
    }

    return RecipeEmptyState(showSavedRecipes: showSavedRecipes);
  }
}
