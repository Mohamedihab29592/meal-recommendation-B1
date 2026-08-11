import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/components/custom_recipes_card.dart';
import 'package:meal_recommendation_b1/core/utiles/helper.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/bloc/RecipeBloc.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/bloc/RecipeEvent.dart';
import '../../../../core/utiles/app_colors.dart';
import '../../data/Recipe.dart';

class SaveRecipeButton extends StatelessWidget {
  final Recipe recipe;

  const SaveRecipeButton({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.zero,
        minimumSize: const Size(48, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () => showSaveConfirmationDialog(context,[recipe]),
      child: const Center(
        child: Icon(
          Icons.save_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}