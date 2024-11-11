import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/Screens/widgets/profile_view_form.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/Screens/widgets/profile_view_header.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/Screens/widgets/profile_view_picture.dart';

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
          padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    ProfileViewHeader(),
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
