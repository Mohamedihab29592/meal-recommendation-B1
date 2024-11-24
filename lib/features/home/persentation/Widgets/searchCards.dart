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
  HomeState homeState;

  SearchCards({required this.homeState});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (homeState is HomeLoaded) {
      final successState = homeState as HomeLoaded;

      if (successState.homeRecipes.isEmpty) {
        return EmptyStateWidget(
          image: Assets.noFoodFound,
          title: "No Recipes Found",
          subtitle: "Add your first recipe and start cooking!",
          onActionPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.addRecipes);
          },
        );
      }
      List<Recipe> filteredRecipeCard = successState.homeRecipes
          .where((element) => element.name.startsWith(query))
          .toList();
      return ListView(
        children: filteredRecipeCard.map((card) {
          return RecipeCardWidget(
            meal: card,
            onTap: () {
              // More robust ID handling
              final recipeId = card.id ?? '';
              print('Attempting to navigate with ID: $recipeId');

              if (recipeId.isNotEmpty) {
                context.pushNamed(AppRoutes.detailsPage, arguments: recipeId);
              } else {
                // Fallback or error handling
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid recipe ID')),
                );
              }
            },
          );
        }).toList(),
      );
    } else if (homeState is FailureState) {
      final failureState = homeState as FailureState;
      return ErrorStateWidget(
        errorMessage:
            failureState.errorMessage ?? "An unexpected error occurred",
        onRetry: () {
          BlocProvider.of<HomeBloc>(context).add(FetchRecipesEvent());
        },
      );
    } else {
      return Column(
        children: List.generate(
          5,
          (_) => const CustomRecipesCardShimmer(),
        ),
      );
    }
  }
}
