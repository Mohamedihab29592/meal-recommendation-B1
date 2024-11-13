import 'package:cloud_firestore/cloud_firestore.dart';

abstract class HomeState{}
class InintialState extends HomeState{}
class IsLoadingHome extends HomeState{}
class SuccessState extends HomeState{
  List<QueryDocumentSnapshot> data = [];
  SuccessState(this.data);
}
class FailureState extends HomeState{
  String? errorMessage;

  FailureState({required this.errorMessage});
}