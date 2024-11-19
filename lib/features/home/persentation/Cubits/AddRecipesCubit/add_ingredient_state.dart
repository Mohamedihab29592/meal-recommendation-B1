import 'package:flutter/cupertino.dart';

@immutable
abstract class AddIngredientState {}

class AddIngredientInitial extends AddIngredientState {}

class AddIngredientLoading extends AddIngredientState {}

class AddIngredientSuccess extends AddIngredientState {}

class AddIngredientFailure extends AddIngredientState {
  final String error;

  AddIngredientFailure(this.error);
}


class IsLoadingImageState extends AddIngredientState {
  final String id;
  IsLoadingImageState(this.id); // Identify the ingredient being updated
}

class LoadedImageState extends AddIngredientState {
  final String id;
  final String imageUrl;
  LoadedImageState(this.id, this.imageUrl);
}

class FailureImageError extends AddIngredientState {
  final String id;
  final String message;
  FailureImageError(this.id, this.message);
}