import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/components/loading_dialog.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeBloc.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeEvent.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeState.dart';
import '../../../../core/components/custom_recipes_card.dart';
import '../../../core/services/di.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(FetchRecipesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: bodyContent(context),
    );
  }

  Widget bodyContent(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is HomeLoaded) {
          var favoriteList = state.favoriteRecipes;

          if (favoriteList.isEmpty) {
            return const Center(
              child: Text(
                "No Favorites Yet!",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.separated(
              itemBuilder: (context, index) {
                var recipe = favoriteList[index];
                var isFavorite = BlocProvider.of<HomeBloc>(context).isFavorite(recipe.id ?? "");

                return CustomRecipesCard(
                  onTapFav: () {
                    BlocProvider.of<HomeBloc>(context).add(ToggleFavoriteEvent(recipe.id ?? ""));
                  },
                  time: recipe.time,
                  middleText: recipe.summary,
                  firstText: recipe.name,
                  ingredients: recipe.ingredients[index].quantity,
                  image: recipe.imageUrl,
                  onTapDelete: () {},
                  mealId: '',
                  isFavorite: isFavorite,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: favoriteList.length,
            ),
          );
        } else if (state is IsLoadingFavorites) {
          return const LoadingDialog();
        } else {
          return const LoadingDialog();
        }
      },
    );
  }
}