import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/custom_recipes_card.dart';
import '../../../../core/utiles/helper.dart';
import '../Cubits/HomeCubit/HomeCubit.dart';

class RecipeCardWidget extends StatelessWidget {
  final dynamic meal;
  final VoidCallback onTap;

  const RecipeCardWidget({
    super.key,
    required this.meal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String mealId = meal["id"] ?? "Unknown ID";
    String mealName = meal["name"]?.isNotEmpty == true
        ? meal["name"]
        : "Unnamed Meal";
    String mealType = meal["typeOfMeal"]?.isNotEmpty == true
        ? meal["typeOfMeal"]
        : "Unknown Type";
    String mealImage = meal["imageUrl"] ?? "";
    String ingredients = meal["ingredients"] != null &&
            meal["ingredients"].isNotEmpty
        ? "${meal["ingredients"].length} ingredients"
        : "No ingredients available";
    String time = meal["time"]?.isNotEmpty == true
        ? "${meal["time"]} min"
        : "N/A";

    return GestureDetector(
      onTap: onTap,
      child: CustomRecipesCard(
        key: ValueKey(mealId),
        onTapDelete: () => _showDeleteDialog(context, mealId),
        onTapFav: () => _addToFavorites(context, mealId),
        firstText: mealType,
        ingredients: ingredients,
        time: time,
        middleText: mealName,
        mealId: mealId,
        image: mealImage,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String mealId) {
    showDeleteDialog(
      context: context,
      mealId: mealId,
      onSuccess: () {
        BlocProvider.of<HomeCubit>(context).getdata();
      },
    );
  }

  void _addToFavorites(BuildContext context, String mealId) {
    // Implement add to favorites logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $mealId to favorites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}