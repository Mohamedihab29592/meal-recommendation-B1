import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Widgets/recipe_card_widget.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utiles/assets.dart';
import '../../../gemini_integrate/data/Recipe.dart';
import '../Cubits/HomeCubit/HomeBloc.dart';
import '../Cubits/HomeCubit/HomeEvent.dart';
import '../Cubits/HomeCubit/HomeState.dart';
import 'custom_recipes_card_shimmer.dart';
import 'empty_state_widget.dart';
import 'error_state_widget.dart';

class RecipesList extends StatelessWidget {
  final HomeLoaded state;
  final bool showFilteredRecipes;

  const RecipesList({
    super.key,
    required this.state,
    this.showFilteredRecipes = false,
  });

  @override
  Widget build(BuildContext context) {
    // Debug print to track state
    _debugPrintRecipeState();

    // Get the recipes to display
    List<Recipe> recipesToShow = _getRecipesToShow(state);

    // Display empty state if no recipes are found
    if (recipesToShow.isEmpty) {
      return _buildEmptyState(context);
    }

    // Build animated list view for recipes
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: recipesToShow.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8.0),
        itemBuilder: (context, index) {
          var recipe = recipesToShow[index];
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: 1.0,
            child: RecipeCardWidget(
              meal: recipe,
              onTap: () => _navigateToRecipeDetails(context, recipe),
            ),
          );
        },
      ),
    );
  }

  // Helper to get recipes to show
  List<Recipe> _getRecipesToShow(HomeLoaded successState) {
    return showFilteredRecipes && successState.filteredRecipes.isNotEmpty
        ? successState.filteredRecipes
        : successState.homeRecipes;
  }

  // Build empty state widget
  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateWidget(
      image: Assets.noFoodFound,
      title: showFilteredRecipes
          ? "No Recipes Match Your Filters"
          : "No Recipes Found",
      subtitle: showFilteredRecipes
          ? "Try adjusting your filter settings."
          : "Add your first recipe to get started!",
      onActionPressed: () {
        if (!showFilteredRecipes) {
          Navigator.of(context).pushNamed(AppRoutes.addRecipes);
        }
      },
    );
  }

  // Debugging method for recipe state
  void _debugPrintRecipeState() {
    print('Filtered Recipes Shown: $showFilteredRecipes');
    print('Total Home Recipes: ${state.homeRecipes.length}');
    print('Filtered Recipes Count: ${state.filteredRecipes.length}');
  }

  // Navigate to recipe details
  void _navigateToRecipeDetails(BuildContext context, Recipe recipe) {
    final recipeId = recipe.id ?? '';
    if (recipeId.isNotEmpty) {
      context.pushNamed(AppRoutes.detailsPage, arguments: recipeId);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid recipe ID')),
      );
    }
  }
}