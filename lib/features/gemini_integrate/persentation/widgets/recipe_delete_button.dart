import 'package:flutter/material.dart';

class RecipeDeleteButton extends StatelessWidget {
  final bool isSaved;
  final VoidCallback? onDelete;

  const RecipeDeleteButton({
    super.key,
    required this.isSaved,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return isSaved && onDelete != null
        ? Positioned(
      top: 10,
      right: 10,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
          tooltip: 'Delete Recipe',
        ),
      ),
    )
        : const SizedBox.shrink();
  }
}
