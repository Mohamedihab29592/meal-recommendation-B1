import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/networking/firebase_error_model.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/bloc/state.dart';
import 'package:meal_recommendation_b1/features/Profile/domain/entity/entity.dart';
import 'package:meal_recommendation_b1/features/Profile/domain/usecase/editUser.dart';
import 'package:meal_recommendation_b1/features/Profile/domain/usecase/getUser.dart';
import 'package:meal_recommendation_b1/features/Profile/domain/usecase/update_user_image_use_case.dart';
import 'event.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfileUseCase getUserProfile;
  final UpdateUserProfileUseCase updateUserProfile;
  final UploadUserProfileImage uploadUserImage;

  UserProfileBloc(
    this.uploadUserImage, {
    required this.getUserProfile,
    required this.updateUserProfile,
  }) : super(UserProfileInitial()) {
    // Register event handlers using on<T>
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UpdateUserProfileImage>(_onUpdateUserImage);
  }

  // Handler for LoadUserProfile event
  File? saveLocallyProfileImage;
  void _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());
    try {
      final user = await getUserProfile(event.userId);
      emit(UserProfileLoaded(user));
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  void _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileUpdating());
    try {
      await updateUserProfile(event.updatedUser as User);
      emit(UserProfileUpdated());
    } catch (e) {
      emit(UserProfileError(e.toString()));
    }
  }

  void _onUpdateUserImage(
    UpdateUserProfileImage event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileUpdating());
    try {
      Either<FirebaseErrorModel, String> result = await uploadUserImage(
          newImage: event.newImageFile, oldImage: event.oldImageFile);
      result.fold((fail) {
        emit(
          UploadUserImageFailure(
              message: fail.message ?? "Can't Upload Your Image"),
        );
      }, (success) {
        emit(
          UploadUserImageSuccess(imageUrl: success),
        );
      });
    } catch (e) {
      emit(
        UploadUserImageFailure(message: e.toString()),
      );
    }
  }
}
