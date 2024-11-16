import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/data_source/data_source.dart';
import 'HomeState.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InintialState());
  String? idDoc;

  List<QueryDocumentSnapshot> dataa = [];
  DataSource datasource = DataSource();

  Future<void> getdata() async {
    emit(IsLoadingHome());
    try {
      dataa.clear(); // Clear existing data
      dataa = await datasource.getdata(); // Fetch new data
      emit(SuccessState(dataa));
    } catch (e) {
      emit(FailureState(errorMessage: "$e"));
    }
  }

  void deleteRecipe(String id) async {
    emit(IsLoadingHome());
    try {
      // Query the database and delete the recipe
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Recipes")
          .where("id", isEqualTo: id)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      // Refresh the data after deletion
      await getdata();
    } catch (e) {
      emit(FailureState(errorMessage: 'Failed to delete recipe.'));
    }
  }
}