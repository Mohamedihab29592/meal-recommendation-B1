import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Widgets/customeListTile.dart';

class IngrediantsScreen extends StatelessWidget {
  const IngrediantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.03), // Responsive padding based on width
        child: ListView(
          children: [
            // Total Ingredients Text
            Text(
              "Total Ingredients: ${BlocProvider.of<DetailsCubit>(context).dataref.first['NOingrediantes']}",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w400,
                fontSize: screenSize.width * 0.05, // Responsive font size
              ),
            ),
            SizedBox(height: screenSize.height * 0.03), // Responsive spacing

            // Ingredients List
            for (int i = 1; i <= 4; i++)
              Column(
                children: [
                  CustomeListTile(
                    ingreName: "${BlocProvider.of<DetailsCubit>(context).dataref.first['ingrediantes']['${_getIngredientKey(i)}']}",
                    NoPieces: "${BlocProvider.of<DetailsCubit>(context).dataref.first['ingrediantes']['${_getPiecesKey(i)}']}",
                  ),
                  Divider(color: AppColors.black),
                  SizedBox(height: screenSize.height * 0.01), // Responsive spacing
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ingrediants
  String _getIngredientKey(int index) {
    switch (index) {
      case 1:
        return 'firstIngrediant';
      case 2:
        return 'secoundIngrediants';
      case 3:
        return 'thirdIngrediants';
      case 4:
        return 'fourthIngrediants';
      default:
        return '';
    }
  }

  String _getPiecesKey(int index) {
    switch (index) {
      case 1:
        return 'firsrpieces';
      case 2:
        return 'secoundpieces';
      case 3:
        return 'threepieces';
      case 4:
        return 'fourpieces';
      default:
        return '';
    }
  }
}