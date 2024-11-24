import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeEvent.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Widgets/recipe_card_widget.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/utiles/assets.dart';
import '../../../gemini_integrate/data/Recipe.dart';
import '../Cubits/HomeCubit/HomeBloc.dart';
import '../Cubits/HomeCubit/HomeState.dart';
import 'custom_recipes_card_shimmer.dart';
import 'empty_state_widget.dart';
import 'error_state_widget.dart';

class SearchCards extends SearchDelegate {
  final HomeState homeState;

  SearchCards({required this.homeState});



  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = ""; // Clear the search query
        },
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context,null); // Close the search delegate


      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // This can display detailed search results if needed
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (homeState is HomeLoaded) {
      final successState = homeState as HomeLoaded;

      if (successState.homeRecipes.isEmpty) {
        return SingleChildScrollView(
          child: EmptyStateWidget(
            image: Assets.noFoodFound,
            title: "No Recipes Found",
            subtitle: "Add your first recipe and start cooking!",
            onActionPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.addRecipes);
            },
          ),
        );
      }

      // Filter recipes based on query
      final filteredRecipes = successState.homeRecipes.where((recipe) {
        final lowerQuery = query.toLowerCase();
        return recipe.name.toLowerCase().contains(lowerQuery) ||
            recipe.summary.toLowerCase().contains(lowerQuery) ||
            recipe.ingredients.any((ingredient) =>
                ingredient.name.toLowerCase().contains(lowerQuery));
      }).toList();

      if (filteredRecipes.isEmpty) {
        return Center(
          child: Text(
            "No recipes match your search.",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        );
      }

      // Display the filtered results
      return ListView.builder(
        itemCount: filteredRecipes.length,
        itemBuilder: (context, index) {
          final recipe = filteredRecipes[index];
          return RecipeCardWidget(
            meal: recipe,
            onTap: () {
              final recipeId = recipe.id ?? '';
              if (recipeId.isNotEmpty) {
                context.pushNamed(AppRoutes.detailsPage, arguments: recipeId);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid recipe ID')),
                );
              }
            },
          );
        },
      );
    } else if (homeState is FailureState) {
      final failureState = homeState as FailureState;
      return ErrorStateWidget(
        errorMessage: failureState.errorMessage ?? "An unexpected error occurred",
        onRetry: () {
          BlocProvider.of<HomeBloc>(context).add(FetchRecipesEvent());
        },
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: List.generate(
            5,
                (_) => const CustomRecipesCardShimmer(),
          ),
        ),
      );
    }
  }
}