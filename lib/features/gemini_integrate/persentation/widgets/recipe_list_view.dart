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
  final ScrollController scrollController;

  const RecipeListView({
    super.key,
    required this.state,
    required this.showSavedRecipes, required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    print('Current State: $state'); // Debug print

    if (state is RecipeLoading) {
      return const LoadingChatWidget();
    }

    // Extract recipes based on state
    final List<Recipe> recipes = _extractRecipes(state);

    // Handle empty state
    if (recipes.isEmpty) {
      return RecipeEmptyState(showSavedRecipes: showSavedRecipes);
    }

    // Handle error state
    if (state is RecipeError) {
      return RecipeErrorView(
        errorMessage: (state as RecipeError).message ,
        onRetry: () => context.read<RecipeBloc>().add(LoadSavedRecipesEvent()),
      );
    }

    // Display recipes
    return ListView.builder(
      itemCount: recipes.length,
      controller: scrollController, // Use the ScrollController here
      padding: const EdgeInsets.only(bottom: 16),
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return RecipeCard(
          recipe: recipe,
          isSaved: showSavedRecipes || state is RetrieveRecipesLoaded,
        );
      },
    );
  }

  List<Recipe> _extractRecipes(RecipeState state) {
    if (state is RecipeLoaded) return state.recipes;
    if (state is SavedRecipesLoaded) return state.savedRecipes;
    if (state is RetrieveRecipesLoaded) return state.savedRecipes;
    return [];
  }
}