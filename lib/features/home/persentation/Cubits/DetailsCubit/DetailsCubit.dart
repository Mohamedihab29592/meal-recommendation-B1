import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/DetailsCubit/DetailsState.dart';
import '../../../data/data_source/data_source.dart';

class DetailsCubit extends Cubit<DetailsState>{
  DetailsCubit():super(InitialState());
  List<QueryDocumentSnapshot> dataref=[];
  DataSource dataSource=DataSource();
  String? reff;
  getDetailsData(context)async{
    emit(IsLoadingDetailsState());
    try {
      dataref.clear;
      dataref=await dataSource.getdatawithid(context);
      emit(SucessState());
      print(dataref);
    } catch (e) {
      print(e);
      emit(FailureState(
        errorMessage: "$e",
      ));
    }
  }

}