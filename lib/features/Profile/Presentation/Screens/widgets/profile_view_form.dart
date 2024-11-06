import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/components/profile_button.dart';
import 'package:meal_recommendation_b1/core/services/form_input_validation.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/Screens/widgets/profile_text_field.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/bloc/bloc.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/bloc/event.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/bloc/state.dart';
import 'package:meal_recommendation_b1/features/Profile/domain/entity/entity.dart';

class ProfileViewForm extends StatefulWidget {
  const ProfileViewForm({
    super.key,
  });

  @override
  State<ProfileViewForm> createState() => _ProfileViewFormState();
}

class _ProfileViewFormState extends State<ProfileViewForm> {
  late TextEditingController nameTextEditingController;

  late TextEditingController emailTextEditingController;

  late TextEditingController phoneTextEditingController;

  TextEditingController imageController = TextEditingController(text: '');

  String imageUrl = '';
  String oldImage = '';
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    _initializeTextControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileLoaded) {
            emailTextEditingController.text = state.user.email;
            nameTextEditingController.text = state.user.name;
            phoneTextEditingController.text = state.user.phone;
            oldImage = state.user.profilePhotoUrl ?? '';
          } else if (state is UserProfileError) {
            customSnackBar(context, message: state.message);
          } else if (state is UploadUserImageFailure) {
            customSnackBar(context, message: state.message);
          } else if (state is UploadUserImageSuccess) {
            imageUrl = state.imageUrl;
            imageController.text = state.imageUrl;
            updateBlocProvider(context);
            BlocProvider.of<UserProfileBloc>(context).saveLocallyProfileImage =
                null;
          } else if (state is UserProfileUpdated) {
            customSnackBar(context, message: "Changes Saved");
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Column(
              children: [
                ProfileTextField(
                  hint: "Name",
                  onSaved: (value) {},
                  controller: nameTextEditingController,
                  validator: FormInputValidation.emptyValueValidation,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 22,
                ),
                ProfileTextField(
                  hint: "Email",
                  controller: emailTextEditingController,
                  onSaved: (value) {},
                  validator: FormInputValidation.emptyValueValidation,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 22,
                ),
                ProfileTextField(
                  hint: "Phone",
                  controller: phoneTextEditingController,
                  onSaved: (value) {},
                  validator: FormInputValidation.emptyValueValidation,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(
                  height: 22,
                ),
                const Expanded(
                  child: SizedBox(
                    height: 25,
                  ),
                ),
                ProfileButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (BlocProvider.of<UserProfileBloc>(context)
                              .saveLocallyProfileImage !=
                          null) {
                        BlocProvider.of<UserProfileBloc>(context).add(
                          UpdateUserProfileImage(
                              oldImageFile: oldImage,
                              newImageFile:
                                  BlocProvider.of<UserProfileBloc>(context)
                                      .saveLocallyProfileImage!),
                        );
                      }
                      formKey.currentState!.save();
                      updateBlocProvider(context);
                    }
                  },
                  text: "Save",
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void customSnackBar(BuildContext context, {required String message}) {
    print(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primary,
        content: Text(
          message,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.024,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  void updateBlocProvider(BuildContext context) {
    BlocProvider.of<UserProfileBloc>(context).add(
      UpdateUserProfile(
        User(
          id: '9uXQoT0sMkfqwhqevcJpfhJSEbm1',
          name: nameTextEditingController.text,
          email: emailTextEditingController.text,
          phone: phoneTextEditingController.text,
          profilePhotoUrl: imageController.text,
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameTextEditingController.dispose();
    emailTextEditingController.dispose();
    phoneTextEditingController.dispose();
    super.dispose();
  }

  Future<void> _initializeTextControllers() async {
    nameTextEditingController = TextEditingController();
    emailTextEditingController = TextEditingController();
    phoneTextEditingController = TextEditingController();
    BlocProvider.of<UserProfileBloc>(context).add(
      LoadUserProfile('9uXQoT0sMkfqwhqevcJpfhJSEbm1'),
    );
  }
}
