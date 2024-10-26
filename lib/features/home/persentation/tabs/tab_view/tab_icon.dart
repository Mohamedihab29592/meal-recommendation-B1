import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utiles/app_colors.dart';

class TabIcon extends StatelessWidget {
  List<bool> selectedWidgets;
  int selectScreen;
  int index;
  String whiteIcon;
  String blueIcon;
  TabIcon({super.key, required this.selectedWidgets, required this.selectScreen, required this.index, required this.blueIcon, required this.whiteIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: 80.w,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedWidgets[index] ? AppColors.primary : AppColors.white
      ),
      child: Image.asset(selectedWidgets[index] ? whiteIcon : blueIcon),
    );
  }
}
