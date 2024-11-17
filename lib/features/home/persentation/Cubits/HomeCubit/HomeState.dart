import 'package:cloud_firestore/cloud_firestore.dart';

abstract class HomeState{}
class InitialState extends HomeState{}
class IsLoadingHome extends HomeState{}
class SuccessState extends HomeState{
  List<dynamic> data = [];
  SuccessState(this.data);
}
class FailureState extends HomeState{
  String? errorMessage;

  FailureState({required this.errorMessage});
}