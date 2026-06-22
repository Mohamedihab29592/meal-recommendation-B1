import 'package:flutter/material.dart';

import '../../../../core/utiles/assets.dart';

class RecipeEmptyState extends StatelessWidget {
  final bool showSavedRecipes;

  const RecipeEmptyState({
    super.key,
    required this.showSavedRecipes,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.noFoodFound),
            const SizedBox(height: 16),
            Text(
              showSavedRecipes
                  ? 'No saved recipes found'
                  : 'Search for recipes or generate new ones',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
