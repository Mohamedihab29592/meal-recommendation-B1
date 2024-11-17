import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/data_source/data_source.dart';
import 'HomeState.dart';
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InintialState());
  String? idDoc;

  List<dynamic> homeRecipes = []; // Initialize with an empty list
  DataSource datasource = DataSource();

  /// Fetch recipes for the logged-in user
  Future<void> getdata() async {
    emit(IsLoadingHome()); // Emit loading state
    try {
      // Ensure user is logged in
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception("No user is logged in.");
      }

      // Fetch the user's document
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();

      // Retrieve or initialize the "recipes" field
      if (userDoc.exists) {
        // Safely fetch the recipes or default to an empty list
        homeRecipes = (userDoc.data() as Map<String, dynamic>?)?["recipes"] ?? [];
        emit(SuccessState(homeRecipes)); // Emit success state with fetched data
      } else {
        homeRecipes = []; // Initialize if the document doesn't exist
        emit(SuccessState([])); // Emit empty state
      }
    } catch (e) {
      emit(FailureState(errorMessage: "$e")); // Emit failure state with error
    }
  }

  /// Delete a recipe by its ID
  Future<void> deleteRecipe(String id) async {
    emit(IsLoadingHome());
    try {
      // Ensure user is logged in
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        throw Exception("No user is logged in.");
      }

      // Fetch the user's document
      DocumentReference userDoc =
      FirebaseFirestore.instance.collection("users").doc(userId);
      DocumentSnapshot snapshot = await userDoc.get();

      if (snapshot.exists) {
        // Retrieve the current recipes
        List<dynamic> recipes = (snapshot.data() as Map<String, dynamic>?)?["recipes"] ?? [];

        // Filter out the recipe to delete
        recipes.removeWhere((recipe) => recipe["id"] == id);

        // Update the document with the modified recipes list
        await userDoc.update({"recipes": recipes});

        // Refresh the data after deletion
        await getdata();
      } else {
        throw Exception("User document does not exist.");
      }
    } catch (e) {
      emit(FailureState(errorMessage: 'Failed to delete recipe: $e'));
    }
  }
}
