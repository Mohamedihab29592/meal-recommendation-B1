import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';

import '../../../../gemini_integrate/data/Recipe.dart';

class DirectionPage extends StatelessWidget {
  final Recipe recipe;

  const DirectionPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final directions = recipe.directions;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(screenSize),
            SizedBox(height: screenSize.height * 0.02),
            _buildStepsList(screenSize, directions,context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(Size screenSize) {
    return Text(
      'Cooking Directions',
      style: TextStyle(
        fontSize: screenSize.width * 0.06,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildStepsList(Size screenSize, Directions directions,BuildContext context) {
    final steps = _extractSteps(directions);

    return steps.isNotEmpty
        ? Column(
      children: steps
          .map((step) => _buildStepCard(
        context: context,
        stepNumber: step['number'],
        stepDescription: step['description'],
        screenSize: screenSize,
      ))
          .toList(),
    )
        : _buildNoStepsPlaceholder(screenSize);
  }

  Widget _buildNoStepsPlaceholder(Size screenSize) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: screenSize.height * 0.1),
        child: Text(
          'No cooking directions available',
          style: TextStyle(
            color: Colors.grey,
            fontSize: screenSize.width * 0.04,
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _extractSteps(Directions directions) {
    final List<Map<String, dynamic>> steps = [
      {'number': 1, 'description': directions.firstStep},
      {'number': 2, 'description': directions.secondStep},
      ...directions.additionalSteps.asMap().entries.map((entry) => {
        'number': entry.key + 3,
        'description': entry.value,
      }),
    ];

    // Remove empty steps
    return steps.where((step) => step['description'].toString().isNotEmpty).toList();
  }

  Widget _buildStepCard({
    required BuildContext context,
    required int stepNumber,
    required String stepDescription,
    required Size screenSize,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: screenSize.height * 0.02),
      padding: EdgeInsets.all(screenSize.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStepNumberBadge(screenSize, stepNumber),
          SizedBox(width: screenSize.width * 0.04),
          _buildStepDescription(screenSize, stepDescription),
        ],
      ),
    );
  }

  Widget _buildStepNumberBadge(Size screenSize, int stepNumber) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$stepNumber',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: screenSize.width * 0.05,
          ),
        ),
      ),
    );
  }

  Widget _buildStepDescription(Size screenSize, String stepDescription) {
    return Expanded(
      child: Text(
        stepDescription,
        style: TextStyle(
          color: Colors.black87,
          fontSize: screenSize.width * 0.04,
          height: 1.5,
        ),
      ),
    );
  }
}