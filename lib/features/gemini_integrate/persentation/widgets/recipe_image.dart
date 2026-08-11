import 'package:flutter/material.dart';
import '../../data/Recipe.dart';

class RecipeImage extends StatelessWidget {
  final Recipe recipe;

  const RecipeImage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'recipe_image_${recipe.name}',
          child: Image.network(
            recipe.imageUrl,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 220,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Text(
              recipe.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
