import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utiles/app_colors.dart';

class TrendingRecipeCard extends StatelessWidget {
  final String imageUrl;
  final String duration;
  final String numberOfIngredients;
  final String typeOfMeal;

  const TrendingRecipeCard(
      {super.key,
      required this.duration,
      required this.typeOfMeal,
      required this.imageUrl,
      required this.numberOfIngredients});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width * .6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.fill,
              ),
            ),
            height: screenSize.height * .15,
            width: screenSize.width * .6,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding:const  EdgeInsets.all(8.0),
              decoration:const BoxDecoration(
                //color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(typeOfMeal,
                      style: TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp)),
                  Row(
                    children: [
                      Text("$numberOfIngredients ",
                          style:
                              TextStyle(color: AppColors.grayInSeeAllScreen)),
                      Text(duration,
                          style: TextStyle(
                              color: AppColors.black, fontSize: 15.sp)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
