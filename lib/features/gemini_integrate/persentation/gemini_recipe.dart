import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/bloc/RecipeBloc.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/widgets/RecipeSearchScreen.dart';
import '../../../core/services/di.dart';

class GeminiRecipePage extends StatelessWidget {
  const GeminiRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  RecipeSearchScreen(), // List of Recipes
    );
  }
}











