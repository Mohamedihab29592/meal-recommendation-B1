import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SideBarItem extends StatelessWidget {
  final int index;
  final String title;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;

  const SideBarItem({
    super.key,
    required this.index,
    required this.title,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.isSelected,
    required this.onTap,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey, required double iconSize, required double fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: isSelected
            ? activeColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: activeColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 16.w,
            ),
            child: Row(
              children: [
                // Animated Icon
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Icon(
                    isSelected ? activeIcon : inactiveIcon,
                    key: ValueKey(isSelected),
                    color: isSelected ? activeColor : inactiveColor,
                    size: 24.w,
                  ),
                ),

                // Spacer
                SizedBox(width: 16.w),

                // Title
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      color: isSelected ? activeColor : inactiveColor,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 16.sp,
                    ),
                    child: Text(title),
                  ),
                ),

                // Selection Indicator
                if (isSelected)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: activeColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
