import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../gemini_integrate/data/Recipe.dart';
import '../../../domain/HomeRepo/HomeRepo.dart';
import 'add_ingredient_state.dart';
import 'package:path/path.dart';

class AddIngredientCubit extends Cubit<AddIngredientState> {
  final HomeRepo homeRepo;
  String? mainImageUrl;
  Map<String, String?> imageUrls = {};

  AddIngredientCubit(this.homeRepo) : super(AddIngredientInitial());

  Future<void> addIngredients(Recipe recipe) async {
    emit(AddIngredientLoading());
    try {
      await homeRepo.addIngredients(recipe);
      emit(AddIngredientSuccess());
    } catch (error) {
      emit(AddIngredientFailure(error.toString()));
    }
  }

  Future<bool> checkIngredientsAdded(Recipe recipe) async {
    try {
       emit(AddIngredientAlreadyAdded());
      return await homeRepo.checkRecipeIngredientsAdded(recipe.id);
    } catch (error) {
      emit(AddIngredientAlreadyFailed(error.toString()));
      print('Error checking ingredients: $error');
      return false;
    }
  }

  Future<void> pickMainImage() async {
    try {
      emit(IsLoadingImageState("main")); // Use "main" as the ID for the main image
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        emit(FailureImageError("main", "No image selected."));
        return;
      }

      final file = File(image.path);
      final imageName = basename(image.path);
      final ref = FirebaseStorage.instance.ref("mainImages/$imageName");

      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      mainImageUrl = url;
      emit(LoadedImageState("main", url)); // Emit a success state with "main" ID
    } catch (e) {
      emit(FailureImageError("main", "Failed to upload image: $e"));
    }
  }

  Future<void> pickImage(String id) async {
    try {
      emit(IsLoadingImageState(id)); // Emit loading state with ID
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        emit(FailureImageError(id, "No image selected."));
        return;
      }

      final file = File(image.path);
      final imageName = basename(image.path);
      final ref = FirebaseStorage.instance.ref("imagesRecipes/$imageName");

      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      imageUrls[id] = url; // Store the URL for this ingredient
      emit(LoadedImageState(id, url)); // Emit success state with specific ID
    } catch (e) {
      emit(FailureImageError(id, "Failed to upload image: $e"));
    }
  }

  String? getImageUrl(String id) {
    if (id == "main") {
      return mainImageUrl;
    }
    return imageUrls[id];
  }
}