import 'dart:io';

import '../../domain/entity/entity.dart';

abstract class UserProfileEvent {}

class LoadUserProfile extends UserProfileEvent {
  final String userId;

  LoadUserProfile(this.userId);
}

class UpdateUserProfile extends UserProfileEvent {
  final User updatedUser;

  UpdateUserProfile(this.updatedUser);
}

class UpdateUserProfileImage extends UserProfileEvent {
  final File newImageFile;
  String? oldImageFile;
  UpdateUserProfileImage({
    this.oldImageFile,
    required this.newImageFile,
  });
}
