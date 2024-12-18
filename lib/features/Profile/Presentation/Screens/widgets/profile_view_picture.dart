import 'dart:io';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/core/utiles/assets.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/bloc/bloc.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/bloc/state.dart';

class ProfileViewPicture extends StatefulWidget {
  const ProfileViewPicture({
    super.key,
  });
  @override
  State<ProfileViewPicture> createState() => _ProfileViewPictureState();
}

class _ProfileViewPictureState extends State<ProfileViewPicture> {
  File? image; // for the image that we have picked now
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UploadUserImageFailure) {}

            return CircleAvatar(
              radius: MediaQuery.of(context).size.height * 0.075,
              backgroundColor: const Color(0xffD9D9D9),
              child: (state is UserProfileLoaded &&
                      state.user.profilePhotoUrl != '')
                  ? ClipOval(
                      child: Image.network(
                        state.user.profilePhotoUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : image != null
                      ? ClipOval(
                          child: Image.file(
                            image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: MediaQuery.of(context).size.height * 0.08,
                          color: Colors.white.withOpacity(0.8),
                        ),
            );
          },
        ),
        Positioned(
          bottom: -MediaQuery.of(context).size.height * 0.013,
          right: -MediaQuery.of(context).size.height * 0.013,
          child: badges.Badge(
            badgeAnimation: const badges.BadgeAnimation.fade(),
            badgeStyle: const badges.BadgeStyle(badgeColor: Colors.transparent),
            badgeContent: IconButton.filled(
              style: IconButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.height * 0.065,
                      MediaQuery.of(context).size.height * 0.065),
                  backgroundColor: AppColors.primary),
              onPressed: () async {
                image = await _selectImageFromGallery();
                BlocProvider.of<UserProfileBloc>(context)
                    .saveLocallyProfileImage = image;

                setState(() {});
              },
              iconSize: MediaQuery.of(context).size.height * 0.026,
              icon: Image.asset(
                Assets.icEdit,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<File?> _selectImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    }
    return null;
  }
}
