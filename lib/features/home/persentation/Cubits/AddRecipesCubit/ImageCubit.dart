import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/AddRecipesCubit/ImageState.dart';

class ImageCubit extends Cubit<ImagesState>{
  String? urlimage;
  String? im;
  File? file;
  ImageCubit():super(VisibleImage());
  //images
  gettimage()async{
    emit(IsLoading());

    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    // Capture a photo.
    // final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    file=File(image!.path);

    var imagename=basename(image.path);

    var refimage=FirebaseStorage.instance.ref("imagesRecipes/$imagename");
    await refimage.putFile(file!);
    urlimage=await refimage.getDownloadURL();
    im=urlimage;
    print(im);
    emit(VisibleImage());
  }
}