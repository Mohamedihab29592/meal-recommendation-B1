import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Import ScreenUtil
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
  List images = [
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
    return Scaffold(
      body: Stack(
        children: [
          // First component in stack (text , circle, points)
          Padding(
            padding: EdgeInsets.all(8.0.sp), // Use ScreenUtil's sp for padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Circle
                Container(
                  margin: EdgeInsets.only(
                      bottom: 60.h), // Use ScreenUtil's h for margin
                  height:
                      320.h, // Height corresponds to h for responsive height
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1.0.sp),
                  ),
                ),
                // Text
                Text(
                  "like in a Restaurant but at home",
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 25.h),
                Center(
                  child: Text(
                    ",consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea qui officia deserunt mollit anim id est laborum.",
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w200),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Texts & points
                SizedBox(height: 70.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skip
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Skip",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15.sp,
                            color: AppColors.primary),
                      ),
                    ),
                    // Points
                    Row(
                      children: [
                        ...List.generate(
                            4,
                            (index) => AnimatedContainer(
                                  margin: EdgeInsets.only(right: 10.sp),
                                  width: 25.sp, // Use ScreenUtil's sp for width
                                  height: 10.sp, // Height for point
                                  duration: Duration(milliseconds: 500),
                                  decoration: BoxDecoration(
                                    color: _currentpage == index
                                        ? AppColors.primary
                                        : Colors.black12,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(4.sp),
                                  ),
                                )),
                      ],
                    ),
                    // Next text
                    _currentpage != 3
                        ? TextButton(
                            onPressed: () {
                              _pageController.nextPage(
                                  duration: Duration(milliseconds: 800),
                                  curve: Curves.decelerate);
                            },
                            child: Text(
                              "Next",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.sp,
                                  color: AppColors.primary),
                            ),
                          )
                        : TextButton(
                            onPressed: () {},
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15.sp,
                                  color: AppColors.primary),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
          // Circle container (second component)
          Container(
            height: 420.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(350.r),
                  bottomRight: Radius.circular(350.r)),
            ),
          ),
          // Third component (logo & image & pageview)
          Padding(
            padding: EdgeInsets.only(top: 50.h),
            child: Column(
              children: [
                // Logo
                Center(
                  child: Image(
                    image: AssetImage("${Assets.icSplash}"),
                    height: 100.h,
                  ),
                ),
                // PageView
                Container(
                  margin: EdgeInsets.only(top: 80.h),
                  height: 280.h,
                  width: 280.w,
                  child: PageView.builder(
                    padEnds: true,
                    onPageChanged: (value) {
                      setState(() {
                        _currentpage = value!;
                      });
                    },
                    controller: _pageController,
                    itemCount: images.length,
                    itemBuilder: (context, index) => CircleAvatar(
                      backgroundImage: AssetImage("${images[index]}"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
