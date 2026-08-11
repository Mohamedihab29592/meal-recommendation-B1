import 'package:flutter/material.dart';
import '../../../../core/utiles/app_colors.dart';

class SavedRecipesToggleButton extends StatelessWidget {
  final bool showSavedRecipes;
  final VoidCallback onToggle;

  const SavedRecipesToggleButton({
    super.key,
    required this.showSavedRecipes,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: showSavedRecipes
            ? AppColors.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        color: AppColors.primary,
        iconSize: 30,
        icon: Icon(
          showSavedRecipes ? Icons.view_list : Icons.save_outlined,
          color: AppColors.primary,
        ),
        onPressed: onToggle,
      ),
    );
  }
}
