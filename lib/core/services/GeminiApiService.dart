import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiApiService {
  final String apiKey;

  GeminiApiService({required this.apiKey});

  Future<Map<String, dynamic>> fetchRecipeFromGemini(String dishName) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    final prompt = '''
Provide detailed recipe information for a dish named "$dishName" in JSON format with the following structure. Do not include image URLs.
    {
  "name": "Dish name",
  "summary": "A summary or brief note about the dish",
  "typeOfMeal": "Type of meal (e.g., Breakfast, Lunch, Dinner, Snack)",
  "time": "Preparation time in minutes",
  "imageUrl":""
  "ingredients": [
    {
      "name": "Ingredient name",
      "quantity": "Quantity of ingredient",
      "unit": "Unit of measurement",
      "imageUrl" : ""
    }
  ],
  "nutrition": {
    "calories": "Calories per serving",
    "protein": "Protein content in grams",
    "carbs": "Carbohydrate content in grams",
    "fat": "Fat content in grams",
    "vitamins": ["List of vitamins (e.g., Vitamin A, Vitamin C, etc.)"]
  },
  "directions": {
    "firstStep": "Detailed description of the first step",
    "secondStep": "Detailed description of the second step",
    "additionalSteps": ["Additional steps as necessary"]
  }
}
    Return the response as JSON.
    ''';

    final response = await model.generateContent([Content.text(prompt)]);
    final cleanedResponse = response.text?.trim().replaceAll('```json', '').replaceAll('```', '').trim();

    return json.decode(cleanedResponse ?? "");
  }
}
