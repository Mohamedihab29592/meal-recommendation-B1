import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';

class DirectionPage extends StatelessWidget {
  final Map<String, dynamic> recipe ;


  const DirectionPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final directions = recipe['directions'] ?? {};

    // Dynamically generate steps based on available data
    final steps = _extractSteps(directions);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Cooking Directions',
              style: TextStyle(
                fontSize: screenSize.width * 0.06,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: screenSize.height * 0.02),

            // Steps List
            ...steps.map((step) => _buildStepCard(
              context: context,
              stepNumber: step['number'],
              stepDescription: step['description'],
              screenSize: screenSize,
            )),

            // No Steps Placeholder
            if (steps.isEmpty)
              Center(
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
              ),
          ],
        ),
      ),
    );
  }

  // Extract steps dynamically from directions
  List<Map<String, dynamic>> _extractSteps(Map<String, dynamic> directions) {
    final List<Map<String, dynamic>> steps = [];

    // Dynamically find steps
    directions.forEach((key, value) {
      if (key.toLowerCase().contains('step') && value is String && value.isNotEmpty) {
        steps.add({
          'number': _extractStepNumber(key),
          'description': value,
        });
      }
    });

    // Sort steps by number
    steps.sort((a, b) => a['number'].compareTo(b['number']));

    return steps;
  }

  // Extract step number from key
  int _extractStepNumber(String key) {
    // Try to extract number from key
    final numberMatch = RegExp(r'\d+').firstMatch(key);
    return numberMatch != null ? int.parse(numberMatch.group(0)!) : 0;
  }

  // Enhanced step card widget
  Widget _buildStepCard( {
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
          // Step Number
          Container(
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
          ),
          SizedBox(width: screenSize.width * 0.04),

          // Step Description
          Expanded(
            child: Text(
              stepDescription,
              style: TextStyle(
                color: Colors.black87,
                fontSize: screenSize.width * 0.04,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}