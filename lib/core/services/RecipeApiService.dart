import 'dart:convert';

import 'package:http/http.dart' as http;
class RecipeApiService {
  final String apiKey;

  RecipeApiService({required this.apiKey});

  Future<String?> fetchRecipeImage(String dishName) async {
    final url = Uri.parse(
      'https://api.spoonacular.com/recipes/complexSearch?query=$dishName&addRecipeInformation=true&apiKey=$apiKey'
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        return data['results'][0]['image'];
      }
    }
    return null;
  }

  Future<String?> fetchIngredientImage(String ingredientName) async {
    final url = Uri.parse(
      'https://api.spoonacular.com/recipes/complexSearch?query=$ingredientName&apiKey=$apiKey'
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        return data['results'][0]['image'];
      }
    }
    return null;
  }
}
