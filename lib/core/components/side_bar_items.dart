import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utiles/app_colors.dart';

class SideBarItems extends StatefulWidget {
  final int index;
  final String whiteIcon;
  final String blueIcon;
  final Function toggleItem;
  final Function returnedIndex;
  final List selected;
  final List items;
  final double iconSize;
  const SideBarItems({super.key, required this.index, required this.whiteIcon, required this.blueIcon, required this.toggleItem, required this.returnedIndex, required this.selected, required this.items, required this.iconSize});

  @override
  State<SideBarItems> createState() => _SideBarItemsState();
}

class _SideBarItemsState extends State<SideBarItems> {


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: widget.selected[widget.index] ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50.w),
          bottomRight: Radius.circular(50.w),
        ),
      ),
      child: Center(
        child: ListTile(
          leading: SvgPicture.asset(
            widget.selected[widget.index] ? widget.whiteIcon : widget.blueIcon,
            width: widget.iconSize,
          ),
          title: Text(widget.items[widget.index],
              style: TextStyle(
                  color: widget.selected[widget.index] ? AppColors.white : AppColors.primary,fontWeight: FontWeight.bold,fontSize: 18.sp)),
          onTap: () {
            widget.returnedIndex(widget.index);
            setState(() {
              widget.toggleItem(widget.index);
            });
          },
        ),
      ),
    );
  }
}