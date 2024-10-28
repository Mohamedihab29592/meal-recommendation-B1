import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/data_source/data_source.dart';
import 'HomeState.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(InintialState());
  List<QueryDocumentSnapshot> dataa = [];
  DataSource datasource = DataSource();

   getdata() async {
    emit(IsLoadingHome());
    try {
        dataa=await datasource.getdata();
      emit(SuccessState());
      print(dataa);
    } catch (e) {
      print(e);
      emit(FailureState(
        errorMessage: "$e",
      ));
    }
  }
}