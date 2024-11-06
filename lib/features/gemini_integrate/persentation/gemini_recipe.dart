import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:pexels_client/pexels_client.dart';
import 'package:http/http.dart' as http;
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
  static const apiGeminiKey = "AIzaSyAKoyYu10J806FFFA7n2KEO7w3hChyL_Pk"; // Replace with your actual API key
  static const spoonacularApiKey = "4dfcf4986aee47f78776848664336a9c";
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
    // Generate recipe data from Gemini
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiGeminiKey,
    );
    final recipeImageUrl = await _fetchRecipeImage(query);

    final prompt = '''
Provide detailed recipe information for a dish named "$query" in JSON format with the following structure. Do not include image URLs.
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

    try {
      final cleanedResponse = response.text?.trim().replaceAll('```json', '').replaceAll('```', '').trim();
      var data = json.decode(cleanedResponse ?? "");

      // Assign the main recipe image URL to the data object
      data['imageUrl'] = recipeImageUrl;

      // Fetch images for each ingredient
      final List<Future<void>> ingredientImageFutures = data['ingredients'].map<Future<void>>((ingredient) async {
        final ingredientName = ingredient['name'] as String;
        final imageUrl = await _fetchIngredientImage(ingredientName);
        ingredient['imageUrl'] = imageUrl;
      }).toList();

      // Wait for all ingredient images to be fetched
      await Future.wait(ingredientImageFutures);

      // Update state with the complete recipe data
      setState(() {
        _recipes = [Recipe.fromJson(data)];
        print('Recipes loaded: ${_recipes.length}');
      });
    } catch (e) {
      print("Error parsing JSON or fetching images: $e");
    }
  }

  Future<String?> _fetchRecipeImage(String dishName) async {
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?query=$dishName&addRecipeInformation=true&apiKey=$spoonacularApiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          return data['results'][0]['image'];
        }
      } else {
        print('Failed to load recipe image: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching recipe image from Spoonacular: $e");
    }
    return null;
  }

  Future<String?> _fetchIngredientImage(String ingredientName) async {
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?query=$ingredientName&apiKey=$spoonacularApiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && data['results'].isNotEmpty) {
          return data['results'][0]['image'];
        }
      } else {
        print('Failed to load ingredient image: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching ingredient image from Spoonacular: $e");
    }
    return null;
  }
}


class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Use a placeholder if imageUrl is null or empty
          recipe.imageUrl != null && recipe.imageUrl.isNotEmpty
              ? Image.network(recipe.imageUrl)
              : Image.network('https://via.placeholder.com/150'),
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
                const Text('Ingredients:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recipe.ingredients.map((ingredient) {
                    return Row(
                      children: [
                        // Use a placeholder if ingredient imageUrl is null or empty
                        ingredient.imageUrl != null && ingredient.imageUrl.isNotEmpty
                            ? Image.network(ingredient.imageUrl, width: 40, height: 40)
                            : Image.network('https://via.placeholder.com/40'),
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











