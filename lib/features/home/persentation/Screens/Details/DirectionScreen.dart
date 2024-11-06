import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsCubit.dart';

class DirectionPage extends StatelessWidget {
  const DirectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04), // Responsive padding based on width
        child: ListView(
          children: [
            // Step 1
            Text(
              "Step 1",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: screenSize.width * 0.06, // Responsive font size
              ),
            ),
            SizedBox(height: screenSize.height * 0.01), // Responsive spacing
            Text(
              "${BlocProvider.of<DetailsCubit>(context).dataref.first['direction']['firststep']}",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w400,
                fontSize: screenSize.width * 0.04, // Responsive font size
              ),
            ),
            SizedBox(height: screenSize.height * 0.02), // Responsive spacing

            // Step 2
            Text(
              "Step 2",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: screenSize.width * 0.06, // Responsive font size
              ),
            ),
            SizedBox(height: screenSize.height * 0.01), // Responsive spacing
            Text(
              "${BlocProvider.of<DetailsCubit>(context).dataref.first['direction']['secoundstep']}",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w400,
                fontSize: screenSize.width * 0.04, // Responsive font size
              ),
            ),
            SizedBox(height: screenSize.height * 0.02), // Responsive spacing
          ],
        ),
      ),
    );
  }
}