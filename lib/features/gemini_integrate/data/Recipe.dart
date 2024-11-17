class Recipe {
  final String name;
  final String summary;
  final String typeOfMeal;
  final String time; // Preparation time
  final String imageUrl; // Main image for the dish
  final List<Ingredient> ingredients;
  final Nutrition nutrition;
  final Directions directions;

  Recipe({
    required this.name,
    required this.summary,
    required this.typeOfMeal,
    required this.time,
    required this.imageUrl,
    required this.ingredients,
    required this.nutrition,
    required this.directions,
  });

  // Factory constructor to parse JSON data
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'] ?? 'Unnamed Recipe',
      summary: json['summary'] ?? 'No summary available',
      typeOfMeal: json['typeOfMeal'] ?? 'Unknown Meal Type',
      time: json['time'] ?? 'N/A',
      imageUrl: json['imageUrl'] ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((ingredientJson) => Ingredient.fromJson(ingredientJson))
          .toList() ??
          [],
      nutrition: json['nutrition'] != null
          ? Nutrition.fromJson(json['nutrition'])
          : Nutrition.defaultValues(),
      directions: json['directions'] != null
          ? Directions.fromJson(json['directions'])
          : Directions.defaultValues(),
    );
  }
}

class Ingredient {
  final String name;
  final String quantity;
  final String unit;
  final String imageUrl;

  Ingredient({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.imageUrl,
  });

  // Factory constructor to parse JSON data
  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? 'Unknown Ingredient',
      quantity: json['quantity'] ?? 'N/A',
      unit: json['unit'] ?? 'N/A',
      imageUrl: json['imageUrl'] ?? '', // Fallback if image URL is missing
    );
  }
}

class Nutrition {
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final List<String> vitamins;

  Nutrition({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.vitamins,
  });

  // Factory constructor to parse JSON data
  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: _parseInt(json['calories']),
      protein: _parseDouble(json['protein']),
      carbs: _parseDouble(json['carbs']),
      fat: _parseDouble(json['fat']),
      vitamins: List<String>.from(json['vitamins'] ?? []),
    );
  }

  // Provide default values if data is missing
  factory Nutrition.defaultValues() {
    return Nutrition(
      calories: 0,
      protein: 0.0,
      carbs: 0.0,
      fat: 0.0,
      vitamins: [],
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

class Directions {
  final String firstStep;
  final String secondStep;
  final List<String> additionalSteps;

  Directions({
    required this.firstStep,
    required this.secondStep,
    required this.additionalSteps,
  });

  // Factory constructor to parse JSON data
  factory Directions.fromJson(Map<String, dynamic> json) {
    return Directions(
      firstStep: json['firstStep'] ?? 'No first step provided',
      secondStep: json['secondStep'] ?? 'No second step provided',
      additionalSteps: List<String>.from(json['additionalSteps'] ?? []),
    );
  }

  // Provide default values if data is missing
  factory Directions.defaultValues() {
    return Directions(
      firstStep: 'N/A',
      secondStep: 'N/A',
      additionalSteps: [],
    );
  }
}
