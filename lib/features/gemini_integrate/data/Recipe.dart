
import '../../../core/utiles/helper.dart';

class Recipe {
  String? id;
  String? generatedAt;
  bool isGenerated;
  bool isArchived;
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
    this.isArchived = false,
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

  // Enhanced factory constructor with detailed error handling and logging
  factory Recipe.fromJson(Map<String, dynamic> json) {
    try {
      // Debug print to see the entire JSON structure
      print('Full Recipe JSON: $json');

      // Detailed type checking and conversion
      return Recipe(
        id: _safeParseString(json['id']),
        name: _safeParseString(json['name'], defaultValue: 'Unnamed Recipe'),
        summary: _safeParseString(json['summary'], defaultValue: 'No summary available'),
        typeOfMeal: _safeParseString(json['typeOfMeal'], defaultValue: 'Unknown Meal Type'),
        time: _safeParseString(json['time'], defaultValue: 'N/A'),
        generatedAt: _safeParseString(json['generatedAt']),
        isGenerated: _safeParseBoolean(json['isGenerated']),
        isArchived: _safeParseBoolean(json['isArchived']),
        sourceQuery: _safeParseString(json['sourceQuery']),
        imageUrl: _safeParseString(json['imageUrl'], defaultValue: ''),

        // Detailed parsing for ingredients
        ingredients: _parseIngredients(json['ingredients']),

        // Detailed parsing for nutrition
        nutrition: json['nutrition'] != null
            ? Nutrition.fromJson(json['nutrition'])
            : Nutrition.defaultValues(),

        // Detailed parsing for directions
        directions: json['directions'] != null
            ? Directions.fromJson(json['directions'])
            : Directions.defaultValues(),
      );
    } catch (e, stackTrace) {
      // Comprehensive error logging
      print('Error parsing Recipe JSON: $e');
      print('JSON causing error: $json');
      print('Stacktrace: $stackTrace');

      // Rethrow or return a default Recipe
      throw ArgumentError('Failed to parse Recipe: $e');
    }
  }

  // Safe string parsing method
  static String _safeParseString(dynamic value, {String defaultValue = ''}) {
    if (value == null) return defaultValue;
    return value.toString().trim().isEmpty ? defaultValue : value.toString();
  }

  // Safe boolean parsing method
  static bool _safeParseBoolean(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return false;
  }

  // Safe ingredients parsing method
  static List<Ingredient> _parseIngredients(dynamic ingredientsJson) {
    try {
      if (ingredientsJson == null) return [];

      if (ingredientsJson is List) {
        return ingredientsJson
            .map((ingredientJson) =>
        ingredientJson is Map
            ? Ingredient.fromJson(ingredientJson as Map<String, dynamic>)
            : Ingredient(
            name: ingredientJson.toString(),
            quantity: 'N/A',
            unit: 'N/A',
            imageUrl: ''
        )
        )
            .toList();
      }

      print('Unexpected ingredients type: ${ingredientsJson.runtimeType}');
      return [];
    } catch (e) {
      print('Error parsing ingredients: $e');
      return [];
    }
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
      'isArchived':isArchived,
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

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    try {
      // Debug print for ingredient parsing
      print('Parsing Ingredient JSON: $json');

      return Ingredient(
        name: safeParseString(json['name'], defaultValue: 'Unknown Ingredient'),
        quantity: safeParseString(json['quantity'], defaultValue: 'N/A'),
        unit: safeParseString(json['unit'], defaultValue: 'N/A'),
        imageUrl: safeParseString(json['imageUrl'], defaultValue: ''),
      );
    } catch (e) {
      print('Error parsing Ingredient: $e');
      throw ArgumentError('Failed to parse Ingredient: $e');
    }
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
    print('Parsing JSON: $json'); // Debugging line
    return Nutrition(
      calories: safeParseInt(json['calories']),
      protein: safeParseDouble(json['protein']),
      carbs: safeParseDouble(json['carbs']),
      fat: safeParseDouble(json['fat']),
      vitamins: parseSafeStringList(json['vitamins']),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'vitamins': vitamins,
    };
  }

  factory Nutrition.defaultValues() {
    return Nutrition(
      calories: 0,
      protein: 0.0,
      carbs: 0.0,
      fat: 0.0,
      vitamins: [],
    );
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
      firstStep: parseSafeString(json['firstStep']),
      secondStep: parseSafeString(json['secondStep']),
      additionalSteps: parseSafeStringList(json['additionalSteps']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstStep': firstStep,
      'secondStep': secondStep,
      'additionalSteps': additionalSteps,
    };
  }

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