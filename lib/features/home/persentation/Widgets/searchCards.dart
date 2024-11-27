import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeEvent.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Widgets/recipe_card_widget.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/di.dart';
import '../../../../core/utiles/assets.dart';
import '../../../gemini_integrate/data/Recipe.dart';
import '../Cubits/HomeCubit/HomeBloc.dart';
import '../Cubits/HomeCubit/HomeState.dart';
import 'custom_recipes_card_shimmer.dart';
import 'empty_state_widget.dart';
import 'error_state_widget.dart';

class SearchCards extends SearchDelegate {
  final HomeBloc homeBloc;

  SearchCards({required this.homeBloc});

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
        close(context, null); // Close the search delegate
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Display the suggestions for now; adjust if detailed results are needed
    return BlocProvider.value(value:getIt<HomeBloc>(),child: buildSuggestions(context));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      bloc: homeBloc, // Explicitly provide the HomeBloc
      builder: (context, state) {
        if (state is HomeLoaded) {
          final recipes = state.homeRecipes;

          // Filter recipes based on the search query
          final filteredRecipes = recipes.where((recipe) {
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

          // Display filtered results
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
        } else if (state is FailureState) {
          return ErrorStateWidget(
            errorMessage: state.errorMessage ?? "An unexpected error occurred",
            onRetry: () {
              homeBloc.add(FetchRecipesEvent());
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
      },
    );
  }
}
