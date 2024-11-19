import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/AddRecipesCubit/add_ingredient_cubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/AddRecipesCubit/add_ingredient_state.dart';
import '../../../../core/components/dynamic_notification_widget.dart';
import '../../../../core/utiles/app_colors.dart';
import '../../data/Recipe.dart';
class AddIngredientsButton extends StatelessWidget {
  final Recipe recipe;

  const AddIngredientsButton({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddIngredientCubit, AddIngredientState>(
      listener: (context, state) {
        if (state is AddIngredientSuccess) {
          DynamicNotificationWidget.showNotification(
            context: context,
            title: 'Oh Hey!!',
            message: 'Ingredients added successfully',
            color: Colors.green, // You can use this color if needed
            contentType: ContentType.success,
            inMaterialBanner: false,
          );
        } else if (state is AddIngredientFailure) {
          DynamicNotificationWidget.showNotification(
            context: context,
            title: 'Oh Hey!!',
            message: 'Failed to add ingredients: ${state.error}',
            color: Colors.green, // You can use this color if needed
            contentType: ContentType.success,
            inMaterialBanner: false,
          );
        }
      },
      builder: (context, state) {
        bool isAdded = state is AddIngredientSuccess;
        bool isLoading = state is AddIngredientLoading;

        return ElevatedButton.icon(
          onPressed: isLoading || isAdded
              ? null
              : () => context.read<AddIngredientCubit>().addIngredients(recipe),
          icon: isLoading
              ? const CircularProgressIndicator()
              : Icon(
            isAdded ? Icons.check_circle : Icons.add_circle_outline,
            color: isAdded ? Colors.green : null,
          ),
          label: Text(
            isAdded ? 'Ingredients Added' : 'Add Ingredients',
            style: TextStyle(
              color: isAdded ? Colors.green : null,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isAdded
                ? Colors.green.shade50
                : AppColors.primary,
            foregroundColor: isAdded
                ? Colors.green
                : Colors.white,
            disabledBackgroundColor: isAdded
                ? Colors.green.shade50
                : Colors.grey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        );
      },
    );
  }
}