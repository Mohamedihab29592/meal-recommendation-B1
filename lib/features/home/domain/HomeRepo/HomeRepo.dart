abstract class HomeRepo{
  Future<void>? sendData({String? typeofmeal, String? mealName, String? ingrediantes, String? time,String? image,String? summary,
    String? protein,String? carb,String? fat,String? kcal,String? vitamins,
    String? firstIngrediants,String? secoundIngrediants,String? thirdIngrediants,String? fourthIngrediants,
    String? firstStep,String? secoundtStep,
    String? piecesone,String? piecestwo,String? piecesthree,String? piecesfour
  }){}
}