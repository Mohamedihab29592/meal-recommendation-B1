import 'package:flutter/material.dart';

import '../utiles/app_colors.dart';
import '../utiles/assets.dart';

class CustomRecipesCard extends StatelessWidget {
  const CustomRecipesCard({
    super.key,
    required this.onTapFav,
    this.time,
    this.firstText,
    this.ingredients,
    this.middleText,
    this.image,
    required this.onTapDelete,
  });

  final String? firstText, middleText, ingredients, time, image;
  final VoidCallback onTapFav;
  final VoidCallback onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image Section
            CircleAvatar(
              radius: 40,
              backgroundImage: image != null && image!.isNotEmpty
                  ? NetworkImage(image!)
                  : const AssetImage(Assets.icSplash) as ImageProvider,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 16),
            // Text and Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    firstText![0].toUpperCase() + firstText!.substring(1) ,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    middleText![0].toUpperCase() + middleText!.substring(1) ?? "Meal Name",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.kitchen, size: 16, color: Colors.blueAccent),
                      const SizedBox(width: 4),
                      Text(
                        ingredients ?? "0 ingredients",
                        style: const TextStyle(fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.timer, size: 16, color: Colors.orangeAccent),
                      const SizedBox(width: 4),
                      Text(
                        time ?? "0 min",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Action Buttons Section
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.favorite_border, color: AppColors.primary, size: 28),
                  onPressed: onTapFav,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent, size: 28),
                  onPressed: onTapDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}