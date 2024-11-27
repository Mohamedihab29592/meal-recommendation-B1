import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/Screens/widgets/profile_view_form.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/Screens/widgets/profile_view_picture.dart';
import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utiles/assets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    SizedBox(
                      height: 23,
                    ),
                    ProfileViewPicture(),
                    SizedBox(
                      height: 22,
                    ),
                    ProfileViewForm()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
