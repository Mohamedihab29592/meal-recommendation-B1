class Recipe {
  final String name;
  final String description;
  final String imageUrl;
  final List<Ingredient> ingredients;
  final List<String> instructions;
  final Nutrition nutrition;

  Recipe({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.nutrition,
  });

  // Define a factory constructor to parse JSON data
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'] ?? 'Unnamed Recipe',
      description: json['description'] ?? 'No description available',
      imageUrl: json['imageUrl'] ?? '', // Fallback if image URL is missing
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((ingredientJson) => Ingredient.fromJson(ingredientJson))
          .toList() ??
          [], // Provide an empty list if ingredients are missing
      instructions: List<String>.from(json['instructions'] ?? []), // Fallback to an empty list if instructions are missing
      nutrition: json['nutrition'] != null
          ? Nutrition.fromJson(json['nutrition'])
          : Nutrition.defaultValues(), // Provide default values if nutrition data is missing
    );
  }
}

class Ingredient {
  final String name;
  final String imageUrl;
  final String quantity;
  final String unit;

  Ingredient({
    required this.name,
    required this.imageUrl,
    required this.quantity,
    required this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? 'Unknown Ingredient',
      imageUrl: json['imageUrl'] ?? '', // Fallback if image URL is missing
      quantity: json['quantity'] ?? 'N/A', // Fallback if quantity is missing
      unit: json['unit'] ?? 'N/A', // Fallback if unit is missing
    );
  }
}

class Nutrition {
  final int calories;
  final double protein;
  final double carbs;
  final double fat;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: _parseInt(json['calories']),
      protein: _parseDouble(json['protein']),
      carbs: _parseDouble(json['carbs']),
      fat: _parseDouble(json['fat']),
    );
  }

  // Provide a default Nutrition object if data is missing
  factory Nutrition.defaultValues() {
    return Nutrition(
      calories: 0,
      protein: 0.0,
      carbs: 0.0,
      fat: 0.0,
    );
  }

  // Helper methods for type conversion
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0; // Default to 0 if unable to parse
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0; // Default to 0.0 if unable to parse
  }
}
