import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';

class SummaryScreen extends StatelessWidget {
  final Map<String, dynamic> recipe;

  const SummaryScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final nutrition = recipe['nutrition'] ?? {};

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenSize.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Section
              _buildSummarySection(context, screenSize),

              // Nutrition Section
              _buildNutritionHeader(screenSize),

              // Macro Nutrients
              _buildMacroNutrients(context, screenSize, nutrition),

              // Additional Nutrition Info
              _buildAdditionalNutrition(context, screenSize, nutrition),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recipe Summary",
          style: TextStyle(
            fontSize: screenSize.width * 0.055,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: screenSize.height * 0.01),
        Text(
          recipe['summary'] ?? 'No summary available',
          style: TextStyle(
            fontSize: screenSize.width * 0.04,
            color: Colors.black87,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: screenSize.height * 0.03),
      ],
    );
  }

  Widget _buildNutritionHeader(Size screenSize) {
    return Text(
      "Nutritional Information",
      style: TextStyle(
        fontSize: screenSize.width * 0.055,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildMacroNutrients(
      BuildContext context, Size screenSize, Map<String, dynamic> nutritions) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomCircle(
            amount: "${nutritions['protein'] ?? '0'}",
            nutrationName: "Protein",
            unit: "g",
            color: Colors.green.shade200,
          ),
          CustomCircle(
            amount: "${nutritions['carb'] ?? '0'}",
            nutrationName: "Carbs",
            unit: "g",
            color: Colors.blue.shade200,
          ),
          CustomCircle(
            amount: "${nutritions['fat'] ?? '0'}",
            nutrationName: "Fat",
            unit: "g",
            color: Colors.orange.shade200,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalNutrition(
      BuildContext context, Size screenSize, Map<String, dynamic> nutritions) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomCircle(
          amount: "${nutritions['kcal'] ?? '0'}",
          nutrationName: "Calories",
          unit: "kcal",
          color: Colors.red.shade200,
        ),
        CustomCircle(
          amount: "${nutritions['vitamins'].length}",
          // Show number of vitamins
          nutrationName: "Vitamins",
          unit: "",
          color: Colors.purple.shade200,
          // Optional: Add a tooltip to show vitamin details
          onTap: () {
            _showVitaminsDialog(context, nutritions['vitamins']);
          },
        ),
      ],
    );
  }
}

void _showVitaminsDialog(BuildContext context, List<dynamic> vitamins) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Vitamins'),
        content: SingleChildScrollView(
          child: ListBody(
            children: vitamins.map((vitamin) {
              // Adjust based on your actual vitamin data structure
              return ListTile(
                title: Text(vitamin.toString()),
              );
            }).toList(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class CustomCircle extends StatelessWidget {
  final String amount;
  final String nutrationName;
  final String unit;
  final Color color;
  final VoidCallback? onTap;

  const CustomCircle({
    super.key,
    required this.amount,
    required this.nutrationName,
    required this.unit,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: screenSize.width * 0.2,
            height: screenSize.width * 0.2,
            decoration: BoxDecoration(
              color: color ?? Colors.blue.shade100,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: screenSize.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    unit,
                    style: TextStyle(
                        fontSize: screenSize.width * 0.03,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: screenSize.height * 0.01),
        Text(
          nutrationName,
          style: TextStyle(
            fontSize: screenSize.width * 0.035,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
