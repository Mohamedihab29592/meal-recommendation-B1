import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utiles/app_colors.dart';

class RecommendedRecipeCard extends StatelessWidget {
  final String imageUrl;
  final String duration;
  final String numberOfIngredients;
  final String typeOfMeal;

  const RecommendedRecipeCard(
      {super.key,
      required this.duration,
      required this.numberOfIngredients,
      required this.typeOfMeal,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(screenSize.width * 0.025),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.025),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            Container(
              width: screenSize.width * 0.5,
              height: screenSize.width * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(
                    imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.favorite_border,
                    color: AppColors.white,
                    size: 40.sp,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  typeOfMeal,
                  style:
                      TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "$numberOfIngredients  ",
                      style: TextStyle(color: AppColors.grayInSeeAllScreen),
                    ),
                    Text(
                      duration,
                      style: TextStyle(color: AppColors.black),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(Icons.star, color: Colors.amber, size: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
