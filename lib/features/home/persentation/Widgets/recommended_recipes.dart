import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';

import '../../../../core/routes/app_routes.dart';

class RecommendedRecipeCard extends StatefulWidget {
  final String recipeId;

  final String imageUrl;
  final String duration;
  final String numberOfIngredients;
  final String typeOfMeal;

  const RecommendedRecipeCard({
    super.key,
    required this.duration,
    required this.numberOfIngredients,
    required this.typeOfMeal,
    required this.imageUrl, required this.recipeId,
  });

  @override
  RecommendedRecipeCardState createState() => RecommendedRecipeCardState();
}

class RecommendedRecipeCardState extends State<RecommendedRecipeCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: (){
            context.pushNamed(AppRoutes.detailsPage, arguments: widget.recipeId);

          },
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.01,
              horizontal: screenSize.width * 0.02,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                _buildRecipeImage(screenSize),

                // Recipe Details Section
                Expanded(
                  child: _buildRecipeDetails(constraints),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecipeImage(Size screenSize) {
    return Stack(
      children: [
        Container(
          width: screenSize.width * 0.35,
          height: screenSize.width * 0.35,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(widget.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 15,
          right: 15,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.7),
            ),
            child: IconButton(
              icon: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite ? Colors.red : Colors.black,
                size: 24.sp,
              ),
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeDetails(BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Recipe Name
          Text(
            widget.typeOfMeal[0].toUpperCase() + widget.typeOfMeal.substring(1),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.sp),

          // Recipe Info Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildRecipeInfoChip(
                  icon: Icons.restaurant_menu,
                  text: widget.numberOfIngredients,
                  color: Colors.green,
                ),
                SizedBox(width: 10.sp),
                _buildRecipeInfoChip(
                  icon: Icons.timer_outlined,
                  text: widget.duration,
                  color: Colors.orange,
                ),
              ],
            ),
          ),

          SizedBox(height: 8.sp),
          _buildRatingSection(),
        ],
      ),
    );
  }
  Widget _buildRatingSection() {
    return Row(
      children: [
        // Animated Star Rating
        ...List.generate(
          5,
              (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Icon(
              Icons.star,
              color: index < 4 ? Colors.amber : Colors.grey[300],
              size: 20.sp,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          '(4.5)',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  Widget _buildRecipeInfoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 2.sp),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}