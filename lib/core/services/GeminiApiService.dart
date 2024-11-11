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
      "description": "Brief description of the dish",
        "imageUrl" : ""
      "ingredients": [
        {
          "name": "Ingredient name",
          "quantity": "Quantity of ingredient",
          "unit": "Unit of measurement"
          "imageUrl" : ""
        }
      ],
      "instructions": ["Step 1", "Step 2", "Step 3"]  ,
      "nutrition": {
        "calories": "Calories per serving",
        "protein": "Protein content",
        "carbs": "Carbohydrate content",
        "fat": "Fat content"
      }
    }
    Return the response as JSON.
    ''';

    final response = await model.generateContent([Content.text(prompt)]);
    final cleanedResponse = response.text?.trim().replaceAll('```json', '').replaceAll('```', '').trim();

    return json.decode(cleanedResponse ?? "");
  }
}
