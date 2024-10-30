import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/core/utiles/assets.dart';

class ProfileViewPicture extends StatelessWidget {
  const ProfileViewPicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: 60.r,
          backgroundColor: const Color(0xffD9D9D9),
          child: Icon(
            Icons.person,
            size: 50.sp,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        Positioned(
          bottom: -10.sp,
          right: -10.sp,
          child: badges.Badge(
            badgeAnimation: const badges.BadgeAnimation.fade(),
            badgeStyle: const badges.BadgeStyle(badgeColor: Colors.transparent),
            badgeContent: IconButton.filled(
              style: IconButton.styleFrom(
                  fixedSize: Size(50.sp, 50.sp),
                  backgroundColor: AppColors.primary),
              onPressed: () {},
              iconSize: 26.sp,
              icon: Image.asset(
                Assets.icEdit,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
