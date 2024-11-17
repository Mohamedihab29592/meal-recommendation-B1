import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import '../../data/Recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add functionality for tapping the card (e.g., navigate to details)
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 5,
        shadowColor: Colors.black45,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section with overlay gradient
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    recipe.imageUrl,
                    height: 180,
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
                        height: 180,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10, // Ensure the text doesn't overflow out of bounds
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        recipe.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // Ensures text overflow works
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Text Section with padding and new styles
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ingredients Count with Icon
                  Row(
                    children: [
                      const Icon(Icons.kitchen, size: 18, color: Colors.blueAccent),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.ingredients.length} Ingredients',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                           const Icon(Icons.timer, size: 18, color: Colors.orangeAccent),
                          const SizedBox(width: 4),
                          Text(
                            '${recipe.time} min',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Center the button
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0), // Padding for spacing
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF001A3F), // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Optional padding for button size
                  ),
                  onPressed: () {
                    // Add functionality for button (e.g., navigate to recipe)
                  },
                  child: const Text(
                    'Add Ingredients',
                    style: TextStyle(
                      color: Colors.white, // Text color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


