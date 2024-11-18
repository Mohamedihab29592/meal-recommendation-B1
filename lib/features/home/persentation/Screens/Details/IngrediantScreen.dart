import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/core/utiles/assets.dart';

import '../../../../gemini_integrate/data/Recipe.dart';

class IngredientsScreen extends StatelessWidget {
  final Recipe recipe ;

  const IngredientsScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final List<Ingredient> ingredients = recipe.ingredients;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(screenSize, ingredients.length),

            SizedBox(height: screenSize.height * 0.02),

            // Ingredients Grid
            _buildIngredientsGrid(context, screenSize, ingredients),

            // No Ingredients Placeholder
            if (ingredients.isEmpty)
              _buildNoIngredientsPlaceholder(screenSize),
          ],
        ),
      ),
    );
  }

  // Header with total ingredients
  Widget _buildHeader(Size screenSize, int totalIngredients) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Ingredients",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: screenSize.width * 0.06,
          ),
        ),
        Text(
          "Total: $totalIngredients",
          style: TextStyle(
            color: AppColors.primary.withOpacity(0.7),
            fontWeight: FontWeight.w500,
            fontSize: screenSize.width * 0.04,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsGrid(BuildContext context, Size screenSize, List<Ingredient> ingredients) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8,
      ),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return _buildIngredientCard(context, screenSize, ingredient);
      },
    );
  }

  // Ingredient Card
  Widget _buildIngredientCard(BuildContext context, Size screenSize, Ingredient ingredient) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ingredient Image
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: _getIngredientImage(ingredient),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Ingredient Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ingredient.name ,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenSize.width * 0.04,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${ingredient.quantity } ${ingredient.unit}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: screenSize.width * 0.035,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Image handling with fallback
  ImageProvider _getIngredientImage(Ingredient ingredient) {
    try {
      // Try network image first
      if (ingredient.imageUrl.isNotEmpty) {
        return NetworkImage(ingredient.imageUrl);
      }
      // Fallback to asset image
      return const AssetImage(Assets.icSplash);
    } catch (e) {
      // Fallback to asset image if any error occurs
      return const AssetImage(Assets.icSplash);
    }
  }

  // No Ingredients Placeholder
  Widget _buildNoIngredientsPlaceholder(Size screenSize) {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.kitchen,
            size: screenSize.width * 0.2,
            color: Colors.grey,
          ),
          const SizedBox(height: 10),
          Text(
            'No ingredients found',
            style: TextStyle(
              color: Colors.grey,
              fontSize: screenSize.width * 0.04,
            ),
          ),
        ],
      ),
    );
  }
}