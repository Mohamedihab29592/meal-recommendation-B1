import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/recipe_card_content.dart';
import '../../../../core/components/dynamic_notification_widget.dart';
import '../../data/Recipe.dart';


class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isSaved;
  final VoidCallback? onDelete;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.isSaved = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () => _handleRecipeTap(context),
            child: Stack(
              children: [
                RecipeCardContent(
                  recipe: recipe,
                  isSaved: isSaved,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRecipeTap(BuildContext context) {
    if (!isSaved) {
      DynamicNotificationWidget.showNotification(
        context: context,
        title: 'Oh Hey!!',
        message: "You Must Save it To Show Details!",
        color: Colors.blueAccent,
        contentType: ContentType.help,
        inMaterialBanner: false,
      );
    } else {
      context.pushNamed(AppRoutes.detailsPage, arguments: recipe.id);
    }
  }
}




