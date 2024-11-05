import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Widgets/CustomeCircle.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.03), // Responsive padding
        child: ListView(
          children: [
            // Summary Text
            Text(
              "${BlocProvider.of<DetailsCubit>(context).dataref.first['summary']}",
              style: TextStyle(fontSize: screenSize.width * 0.04), // Responsive font size
            ),
            SizedBox(height: screenSize.height * 0.02), // Responsive spacing
            Text(
              "Nutrations",
              style: TextStyle(fontSize: screenSize.width * 0.06, fontWeight: FontWeight.bold), // Responsive font size
            ),
            SizedBox(height: screenSize.height * 0.02), // Responsive spacing

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // Change to spaceAround for better spacing on smaller devices
              children: [
                CustomeCircle(
                  amount: "${BlocProvider.of<DetailsCubit>(context).dataref.first['nutrations']['protein']}",
                  nutrationName: "Protein",
                  unit: "g",
                ),
                CustomeCircle(
                  amount: "${BlocProvider.of<DetailsCubit>(context).dataref.first['nutrations']['carb']}",
                  nutrationName: "Carb",
                  unit: "g",
                ),
                CustomeCircle(
                  amount: "${BlocProvider.of<DetailsCubit>(context).dataref.first['nutrations']['fat']}",
                  nutrationName: "Fat",
                  unit: "g",
                ),
              ],
            ),
            SizedBox(height: screenSize.height * 0.001), // Responsive spacing

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomeCircle(
                  amount: "${BlocProvider.of<DetailsCubit>(context).dataref.first['nutrations']['kcal']}",
                  nutrationName: "Kcal",
                  unit: "",
                ),
                CustomeCircle(
                  amount: "${BlocProvider.of<DetailsCubit>(context).dataref.first['nutrations']['vitamins']}",
                  nutrationName: "Vitamins",
                  unit: "",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}