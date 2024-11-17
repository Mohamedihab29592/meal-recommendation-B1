import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';

import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utiles/assets.dart';
import '../bloc/RecipeBloc.dart';
import '../bloc/RecipeEvent.dart';
import '../bloc/RecipeState.dart';
import 'CustomSearchBar.dart';
import 'RecipeCard.dart';

class RecipeSearchScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  RecipeSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomAppbar(
                ontapleft: () {},
                ontapright: () {
                  context.pushNamed(AppRoutes.geminiRecipe);
                },
                rightChild: const SizedBox(),
                leftImage: Assets.icProfileMenu,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<RecipeBloc, RecipeState>(
                  builder: (context, state) {
                    if (state is RecipeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RecipeLoaded) {
                      return ListView.builder(
                        itemCount: state.recipes.length,
                        padding: const EdgeInsets.only(bottom: 16),
                        itemBuilder: (context, index) {
                          final recipe = state.recipes[index];
                          return RecipeCard(recipe: recipe);
                        },
                      );
                    } else if (state is RecipeError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return Image.asset(Assets.noFoodFound);
                  },
                ),
              ),
              CustomSearchBar(
                controller: _controller,
                onSearch: (query) {
                  if (query.isNotEmpty) {
                    context.read<RecipeBloc>().add(FetchRecipesEvent(query));
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}