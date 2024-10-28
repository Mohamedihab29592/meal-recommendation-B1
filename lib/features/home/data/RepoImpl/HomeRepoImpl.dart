import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meal_recommendation_b1/features/home/domain/HomeRepo/HomeRepo.dart';

class HomeRepoImpl extends HomeRepo{
  @override
  Future<void>? sendData(String typeofmeal, String mealName, String ingrediantes, String time,String image) {
    CollectionReference addRecipes=FirebaseFirestore.instance.collection("Recipes");
    return addRecipes.add({
      "typeofmeal":typeofmeal,
      "mealName":mealName,
      "NOingrediantes":ingrediantes,
      "time":time,
      "image":image,
    });
  }
}