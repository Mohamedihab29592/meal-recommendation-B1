import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/home/domain/HomeRepo/HomeRepo.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/AddRecipesCubit/ImageCubit.dart';

class HomeRepoImpl extends HomeRepo{
  @override
 sendData({String? typeofmeal, String? mealName, String? ingrediantes, String? time,String? image,String? summary,
      String? protein,String? carb,String? fat,String? kcal,String? vitamins,
      String? firstIngrediants,String? secoundIngrediants,String? thirdIngrediants,String? fourthIngrediants,
    String? firstStep,String? secoundtStep,
    String? piecesone,String? piecestwo,String? piecesthree,String? piecesfour,
  }) {
    CollectionReference addRecipes=FirebaseFirestore.instance.collection("Recipes");
    return addRecipes.add({
      "uid":FirebaseAuth.instance.currentUser!.uid,
      "id":FirebaseFirestore.instance.collection("Recipes").doc().id,
      "typeofmeal":typeofmeal,
      "mealName":mealName,
      "NOingrediantes":ingrediantes,
      "time":time,
      "image":image,
      "summary":summary,
      "nutrations":{
        "protein":protein,
        "carb":carb,
        "fat":fat,
        "kcal":kcal,
        "vitamins":vitamins,
      },
      "ingrediantes":{
        "firstIngrediant":firstIngrediants,
        "secoundIngrediants":secoundIngrediants,
        "thirdIngrediants":thirdIngrediants,
        "fourthIngrediants":fourthIngrediants,
        "firsrpieces":piecesone,
        "secoundpieces":piecestwo,
        "threepieces":piecesthree,
        "fourpieces":piecesfour,
      },
      "direction":{
        "firststep":firstStep,
        "secoundstep":secoundtStep,
      }

    });
  }
}