import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Widgets/recipe_card_widget.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utiles/assets.dart';
import '../../../gemini_integrate/data/Recipe.dart';
import '../Cubits/HomeCubit/HomeCubit.dart';
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
    _debugPrintRecipeState();

    // Determine which list of recipes to show
    List<Recipe> recipesToShow = _getRecipesToShow(state);

    // Check if there are no recipes to show
    if (recipesToShow.isEmpty) {
      return _buildEmptyState(context);
    }

    // Display the list of recipes with animation
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListView.builder(
        key: ValueKey(state.stateId), // Use stateId as key to force rebuild
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recipesToShow.length,
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

  // Determine which recipes to show
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
          ? "Try adjusting your filter settings"
          : "Add your first recipe and start cooking!",
      onActionPressed: () {
        if (!showFilteredRecipes) {
          Navigator.of(context).pushNamed(AppRoutes.addRecipes);
        }
      },
    );
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

  // Debug print to track recipe state
  void _debugPrintRecipeState() {
    print('Showing Filtered Recipes: $showFilteredRecipes');
    print('Total Home Recipes: ${state.homeRecipes.length}');
    print('Total Filtered Recipes: ${state.filteredRecipes.length}');
  }
}