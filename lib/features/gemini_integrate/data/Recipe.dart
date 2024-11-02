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
            name: json['name'],
            description: json['description'],
            imageUrl: json['imageUrl'],
            ingredients: (json['ingredients'] as List)
          .map((ingredientJson) => Ingredient.fromJson(ingredientJson))
          .toList(),
            instructions: List<String>.from(json['instructions']),
            nutrition: Nutrition.fromJson(json['nutrition']),
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
            name: json['name'],
            imageUrl: json['imageUrl'],
            quantity: json['quantity'],
            unit: json['unit'],
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
            calories: json['calories'],
            protein: json['protein'],
            carbs: json['carbs'],
            fat: json['fat'],
    );
  }
}