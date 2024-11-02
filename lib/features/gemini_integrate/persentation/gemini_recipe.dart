import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:pexels_client/pexels_client.dart';

import '../data/Recipe.dart';

class GeminiRecipe extends StatefulWidget {
  const GeminiRecipe({super.key});

  @override
  GeminiRecipeState createState() => GeminiRecipeState();
}

class GeminiRecipeState extends State<GeminiRecipe> {
  final _formKey = GlobalKey<FormState>();
  String _searchQuery = "";
  List<Recipe> _recipes = [];
  static const apiGeminiKey =
      "AIzaSyAKoyYu10J806FFFA7n2KEO7w3hChyL_Pk"; // Replace with your actual API key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Finder')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Enter food name'),
                onChanged: (value) {
                  _searchQuery = value;
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_searchQuery.isNotEmpty) {
                  _fetchRecipes(_searchQuery);
                }
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  final recipe = _recipes[index];
                  return RecipeCard(recipe: recipe);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchRecipes(String query) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiGeminiKey,
    );

    final prompt = '''
Provide detailed recipe information for a dish named "$query" in JSON format with the following structure. Ensure all image URLs are verified and accessible, using high-quality sources such as Pexels.
  {
    "name": "Dish name",
    "description": "Brief description of the dish",
    "imageUrl": "Accessible URL to an image of the dish (find image using 'pexels $query')",
    "ingredients": [
      {
        "name": "Ingredient name",
        "quantity": "Quantity of ingredient",
        "unit": "Unit of measurement",
        "imageUrl": "Accessible URL to an image of the ingredient from a reliable source (find image using 'pexels ingredient name')"
      }
    ],
    "instructions": ["Step 1", "Step 2", "Step 3"],
    "nutrition": {
      "calories": "Calories per serving",
      "protein": "Protein content",
      "carbs": "Carbohydrate content",
      "fat": "Fat content"
    }
  }
  Ensure all data is formatted correctly as JSON and that URLs are verified to avoid parsing or loading errors.
  ''';

    final response = await model.generateContent([Content.text(prompt)]);

    try {
      // Clean up response text to remove unwanted backticks or surrounding text
      final cleanedResponse = response.text?.trim().replaceAll('```json', '').replaceAll('```', '').trim();
      final data = json.decode(cleanedResponse ?? "");

      // Initialize Pexels client
      final pexelsClient = PexelsClient(apiKey: 'YOUR_PEXELS_API_KEY'); // Replace with your Pexels API key

      // Fetch ingredient images asynchronously based on each ingredient name
      final List<Future<void>> ingredientFutures = data['ingredients'].map<Future<void>>((ingredient) async {
        final ingredientQuery = ingredient['name'] ?? 'Ingredient';
        final ingredientImageResults = await pexelsClient.searchPhotos(query: ingredientQuery, perPage: 1);

        // Check if results are not null and contain photos before accessing 'original'
        ingredient['imageUrl'] = (ingredientImageResults != null && ingredientImageResults.photos!.isNotEmpty )
            ? ingredientImageResults.photos![0].src?.original
            : null;
      }).toList();

      // Wait for all ingredient images to be fetched
      await Future.wait(ingredientFutures);

      setState(() {
        _recipes = [Recipe.fromJson(data)];
      });
    } catch (e) {
      print("Error parsing JSON or fetching images: $e");
      print("Response text was: ${response.text}");
    }
  }
}

// Model for the Recipe, Ingredient, and Nutrition information



// Widget to display individual recipe information
class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(recipe.imageUrl),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
                Text(recipe.description),
                const SizedBox(height: 10),
                Text('Ingredients:',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.ingredients.map((ingredient) {
                    return Row(
                      children: [
                        Image.network(ingredient.imageUrl,
                            width: 40, height: 40),
                        const SizedBox(width: 8),
                        Text(
                            '${ingredient.quantity} ${ingredient.unit} ${ingredient.name}'),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                const Text('Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.instructions
                      .map((instruction) => Text('- $instruction'))
                      .toList(),
                ),
                const SizedBox(height: 10),
                const Text('Nutrition Info:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('Calories: ${recipe.nutrition.calories} kcal'),
                Text('Protein: ${recipe.nutrition.protein} g'),
                Text('Carbs: ${recipe.nutrition.carbs} g'),
                Text('Fat: ${recipe.nutrition.fat} g'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}













