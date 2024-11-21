import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:shimmer/shimmer.dart';

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
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: _buildIngredientImage(ingredient, screenSize),
            ),
          ),

          // Ingredient Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ingredient.name,
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
                    "${ingredient.quantity} ${ingredient.unit}",
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

  Widget _buildIngredientImage(Ingredient ingredient, Size screenSize) {
    // If no image URL, return default image
    if (ingredient.imageUrl.isEmpty) {
      return _buildDefaultImage(screenSize);
    }

    return CachedNetworkImage(
      imageUrl: ingredient.imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => _buildLoadingPlaceholder(screenSize),
      errorWidget: (context, url, error) => _buildErrorImage(screenSize),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.primary.withOpacity(0.3),
              BlendMode.srcATop,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultImage(Size screenSize) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.food_bank_outlined,
          color: Colors.grey.shade400,
          size: screenSize.width * 0.1,
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder(Size screenSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorImage(Size screenSize) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.red.shade300,
          size: screenSize.width * 0.1,
        ),
      ),
    );
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