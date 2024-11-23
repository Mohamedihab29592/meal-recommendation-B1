import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/custom_recipes_card.dart';
import '../../../../core/components/dynamic_notification_widget.dart';
import '../../../../core/utiles/helper.dart';
import '../../../gemini_integrate/data/Recipe.dart';
import '../Cubits/HomeCubit/HomeCubit.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class RecipeCardWidget extends StatelessWidget {
  final Recipe meal;
  final VoidCallback onTap;

  const RecipeCardWidget({
    super.key,
    required this.meal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String mealId = meal.id ?? "Unknown ID";
    String mealName = meal.name.isNotEmpty
        ? meal.name
        : "Unnamed Meal";
    String mealType = meal.typeOfMeal.isNotEmpty == true
        ? meal.typeOfMeal!
        : "Unknown Type";

    String mealImage = meal.imageUrl;

    // For ingredients, you'll need to modify based on your Recipe model
    String ingredients = "${meal.ingredients.length} Ingredients";

    String time = meal.time != null
        ? "${meal.time} min"
        : "N/A";

    return GestureDetector(
      onTap: onTap,
      child: CustomRecipesCard(
        key: ValueKey(mealId),
        onTapDelete: () => _showDeleteDialog(context, mealId),
        onTapFav: () => _addToFavorites(context, mealId),
        firstText: mealType,
        ingredients: ingredients,
        isFavorite:isFavorite(context,mealId),
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
    BlocProvider.of<HomeCubit>(context).toggleFavoriteLocal(mealId);
  }

  bool isFavorite(BuildContext context, String mealId){
    return BlocProvider.of<HomeCubit>(context).isFavorite(mealId);
  }
}