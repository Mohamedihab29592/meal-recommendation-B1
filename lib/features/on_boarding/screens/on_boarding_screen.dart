import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Screens/HomePage.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Screens/NavBarPage.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utiles/assets.dart';
import '../../../core/utiles/app_colors.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // Classes objects
  AppColors appcolor = AppColors();
  Assets assets = Assets();

  // List of images
  List<String> images = [
    Assets.firstOnbordingLogo,
    Assets.secoundtOnbordingLogo,
    Assets.thirdOnbordingLogo,
    Assets.secoundtOnbordingLogo,
  ];

  // Global variables
  int _currentpage = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // Getting screen size
    final Size screenSize = MediaQuery.of(context).size;
    final double height = screenSize.height;
    final double width = screenSize.width;

    return  Scaffold(
      body: Stack(
        children: [
          // First component in stack (text, circle, points)
          Center(
            child: Container(
              height: 310, // Set height directly
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 1.0),
              ),
            ),
          ),

          // Circle container (second component oval)
          Container(
            height: 450.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(400),
                bottomRight: Radius.circular(400),
              ),
            ),
          ),

          // Third component (logo & image & pageview)
          Padding(
            padding: EdgeInsets.only(top: height * 0.1), // Top padding relative to screen height
            child: Column(
              children: [
                // Logo
                Center(
                  child: Image(
                    image: AssetImage(Assets.icSplash),
                    height: height * 0.1, // 10% of screen height
                  ),
                ),
                // PageView
                Container(
                  margin: EdgeInsets.only(top: height * 0.1), // Margin relative to screen height
                  height: height * 0.35, // 35% of screen height
                  width: width * 0.7, // 70% of screen width
                  child: PageView.builder(
                    padEnds: true,
                    onPageChanged: (value) {
                      setState(() {
                        _currentpage = value;
                      });
                    },
                    controller: _pageController,
                    itemCount: images.length,
                    itemBuilder: (context, index) => CircleAvatar(
                      backgroundImage: AssetImage(images[index]),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Text & points
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Text
                Text(
                  "Like in a Restaurant but at Home",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Defined in logical units
                ),
                SizedBox(height: height * 0.03), // 3% of screen height
                Center(
                  child: Text(
                    ", consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea qui officia deserunt mollit anim id est laborum.",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Texts & points
                SizedBox(height: height * 0.05), // 10% of screen height
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, AppRoutes.login);
                      },
                      child: Text(
                        "Skip",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    // Points
                    Row(
                      children: List.generate(
                        images.length,
                            (index) => AnimatedContainer(
                          margin: EdgeInsets.only(right: 10),
                          width: 25, // Fixed width for points
                          height: 10, // Fixed height for points
                          duration: Duration(milliseconds: 500),
                          decoration: BoxDecoration(
                            color: _currentpage == index
                                ? AppColors.primary
                                : Colors.black12,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    // Next text
                    _currentpage != images.length - 1
                        ? TextButton(
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 800),
                          curve: Curves.decelerate,
                        );
                      },
                      child: Text(
                        "Next",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                        : TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.login);
                        // Navigator.of(context).pushReplacementNamed(AppRoutes.navBar);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

);
  }
}