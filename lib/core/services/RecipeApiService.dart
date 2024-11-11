import 'dart:convert';

import 'package:pexels_client/pexels_client.dart';
import 'package:http/http.dart' as http;

class RecipeApiService {
  final PexelsClient _pexelsClient;

  RecipeApiService({required String apiKey}) : _pexelsClient = PexelsClient(apiKey: apiKey);

  Future<String?> fetchRecipeImage(String dishName) async {
    final url = Uri.parse(
        'https://api.spoonacular.com/recipes/complexSearch?query=$dishName&addRecipeInformation=true&apiKey=4dfcf4986aee47f78776848664336a9c'
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
    try {
      final photos = await _pexelsClient.searchPhotos(query: ingredientName, perPage: 1);
      if (photos!.photos!.isNotEmpty ) {

        return photos.photos!.first.src!.original ?? photos.photos!.first.src!.large;
      }
    } catch (e) {
      print('Error fetching ingredient image: $e');
    }
    return null;
  }
}
