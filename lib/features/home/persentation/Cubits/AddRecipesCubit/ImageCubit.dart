import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/AddRecipesCubit/ImageState.dart';

class ImageCubit extends Cubit<ImagesState> {
  String? mainImageUrl;
   Map<String, String?> imageUrls = {};

  ImageCubit() : super(ImagesInitial());

  // Picking the main image
  Future<void> pickMainImage() async {
    try {
      emit(IsLoadingState("main")); // Use "main" as the ID for the main image
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

  // Picking ingredient-specific images
  Future<void> pickImage(String id) async {
    try {
      emit(IsLoadingState(id)); // Emit loading state with ID
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

  // Retrieve image URLs
  String? getImageUrl(String id) {
    if (id == "main") {
      return mainImageUrl;
    }
    return imageUrls[id];
  }
}
