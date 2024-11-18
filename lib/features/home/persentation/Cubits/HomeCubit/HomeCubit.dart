import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'HomeState.dart';
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InitialState());

  List<dynamic> homeRecipes = [];

  Future<void> getdata() async {
    emit(IsLoadingHome());
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(FailureState(errorMessage: "No user is logged in."));
        return;
      }

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // Safely fetch the recipes or default to an empty list
        homeRecipes =
            (userDoc.data() as Map<String, dynamic>?)?["recipes"] ?? [];

        print('Fetched recipes: $homeRecipes'); // Debug print

        emit(SuccessState(homeRecipes));
      } else {
        homeRecipes = []; // Initialize if the document doesn't exist
        emit(SuccessState([]));
      }
    } catch (e) {
      print('Error fetching data: $e'); // Debug print
      emit(FailureState(errorMessage: "$e"));
    }
  }

  Future<void> deleteRecipe(String id) async {
    emit(IsLoadingHome());
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(FailureState(errorMessage: "No user is logged in."));
        return;
      }

      DocumentReference userDoc =
      FirebaseFirestore.instance.collection("users").doc(userId);
      DocumentSnapshot snapshot = await userDoc.get();

      if (snapshot.exists) {
        List<dynamic> recipes =
            (snapshot.data() as Map<String, dynamic>?)?["recipes"] ?? [];

        recipes.removeWhere((recipe) => recipe["id"] == id);

        await userDoc.update({"recipes": recipes});

        // Directly update the state after deletion
        homeRecipes = recipes;
        emit(SuccessState(homeRecipes));
      } else {
        emit(FailureState(errorMessage: "User document does not exist."));
      }
    } catch (e) {
      emit(FailureState(errorMessage: 'Failed to delete recipe: $e'));
    }
  }
}
