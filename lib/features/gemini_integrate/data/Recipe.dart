import 'package:meal_recommendation_b1/features/gemini_integrate/data/RecipeRepository.dart';

class Recipe {
  String? id;
  String? generatedAt;
  bool isGenerated;
  String? sourceQuery;
  final String name;
  final String summary;
  final String typeOfMeal;
  final String time;
  final String imageUrl;
  final List<Ingredient> ingredients;
  final Nutrition nutrition;
  final Directions directions;

  Recipe({
    this.id,
    this.generatedAt,
    this.isGenerated = false,
    this.sourceQuery,
    required this.name,
    required this.summary,
    required this.typeOfMeal,
    required this.time,
    required this.imageUrl,
    required List<Ingredient> ingredients,
    required this.nutrition,
    required this.directions,
  }) : ingredients = List.unmodifiable(ingredients) {
    _validate();
  }

  // Factory constructor to parse JSON data
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'] ?? 'Unnamed Recipe',
      summary: json['summary'] ?? 'No summary available',
      typeOfMeal: json['typeOfMeal'] ?? 'Unknown Meal Type',
      time: json['time'] ?? 'N/A',
      generatedAt: json['generatedAt'],
      isGenerated: json['isGenerated'] ?? false,
      sourceQuery: json['sourceQuery'],
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'summary': summary,
      'typeOfMeal': typeOfMeal,
      'time': time,
      'imageUrl': imageUrl,
      'generatedAt': generatedAt,
      'isGenerated': isGenerated,
      'sourceQuery': sourceQuery,
      'ingredients':
          ingredients.map((ingredient) => ingredient.toJson()).toList(),
      'nutrition': nutrition.toJson(),
      'directions': directions.toJson(),
    };
  }

  // Validation method to ensure required fields are not empty
  void _validate() {
    if (name.isEmpty || summary.isEmpty || typeOfMeal.isEmpty) {
      throw ArgumentError('Name, summary, and typeOfMeal cannot be empty.');
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Recipe && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Recipe{id: $id, name: $name, summary: $summary, typeOfMeal: $typeOfMeal, time: $time}';
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'Ingredient{name: $name, quantity: $quantity $unit}';
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
    required List<String> vitamins,
  }) : vitamins = List.unmodifiable(vitamins);

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
  Map<String, dynamic> toJson() {
    return {
      'calories': calories  ,
      'protein': protein,
      'carbs': carbs,
      'vitamins': vitamins,
    };
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

  @override
  String toString() {
    return 'Nutrition{calories: $calories, protein: $protein, carbs: $carbs, fat: $fat, vitamins: $vitamins}';
  }
}

class Directions {
  final String firstStep;
  final String secondStep;
  final List<String> additionalSteps;

  Directions({
    required this.firstStep,
    required this.secondStep,
    required List<String> additionalSteps,
  }) : additionalSteps = List.unmodifiable(additionalSteps);

  // Factory constructor to parse JSON data
  factory Directions.fromJson(Map<String, dynamic> json) {
    return Directions(
      firstStep: json['firstStep'] ?? 'No first step provided',
      secondStep: json['secondStep'] ?? 'No second step provided',
      additionalSteps: List<String>.from(json['additionalSteps'] ?? []),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'firstStep': firstStep  ,
      'secondStep': secondStep,
      'additionalSteps': additionalSteps,
    };
  }
  // Provide default values if data is missing
  factory Directions.defaultValues() {
    return Directions(
      firstStep: 'N/A',
      secondStep: 'N/A',
      additionalSteps: [],
    );
  }

  @override
  String toString() {
    return 'Directions{firstStep: $firstStep, secondStep: $secondStep, additionalSteps: $additionalSteps}';
  }
}
