import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/home/persentation/Cubits/HomeCubit/HomeCubit.dart';
import '../utiles/app_colors.dart';
import '../utiles/assets.dart';
import '../utiles/helper.dart';

class CustomRecipesCard extends StatelessWidget {
  const CustomRecipesCard({
    super.key,
    required this.onTapFav,
    this.time,
    this.firstText,
    this.ingredients,
    this.middleText,
    this.image,
    required this.onTapDelete, required this.mealId,
  });

  final String? firstText, middleText, ingredients, time, image;
  final VoidCallback onTapFav;
  final VoidCallback onTapDelete;
  final String mealId; // Add mealId to the constructor

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        // Call your existing delete dialog method
        _showDeleteDialog( context,mealId,context.read<HomeCubit>());
        return false; // Prevent automatic dismissal
      },
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        elevation: 5,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: image != null && image!.isNotEmpty
                    ? NetworkImage(image!)
                    : const AssetImage(Assets.icSplash) as ImageProvider,
                backgroundColor: Colors.grey[200],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      firstText![0].toUpperCase() + firstText!.substring(1),
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
                        Expanded(
                          child: Text(
                            ingredients ?? "0 ingredients",
                            style: const TextStyle(fontSize: 13, color: Colors.black54),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
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
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Action Buttons Section
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: AppColors.primary, size: 32),
                    onPressed: onTapFav,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showDeleteDialog(BuildContext context, String mealId, HomeCubit homeCubit) {
  showDeleteDialog(
    context: context,
    mealId: mealId,
    onSuccess: () {
      homeCubit.getdata();
    },
  );
}