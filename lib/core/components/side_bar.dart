import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/components/side_bar_items.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import '../utiles/app_strings.dart';
import '../utiles/assets.dart';

class SideBar extends StatefulWidget {
  final int oldIndex;
  final Function returnedIndex;
  const SideBar({super.key, required this.oldIndex, required this.returnedIndex});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  double spaceBetweenItems = 30.h;

  List items = [
    AppStrings.home,
    AppStrings.favorites,
    AppStrings.profile,
    AppStrings.settings
  ];
  List selected = [true, false, false, false];
  int selectItem = 0;

  void toggleItem(int index) {
    setState(() {
      for (int i = 0; i < selected.length; i++) {
        selected[i] = false;
      }
      selected[index] = true;
      selectItem = index;
    });
  }

  @override
  void initState() {
    selectItem = widget.oldIndex;
    toggleItem(selectItem);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height / 4,
            padding: EdgeInsets.all(20.w),
            color: AppColors.primary,
            child: Center(
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                      radius: 50.r,
                      foregroundImage: const AssetImage(
                        Assets.icSplash,
                      )),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text('User name',
                      style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: spaceBetweenItems,
          ),
          Container(
            padding: EdgeInsets.only(right: 40.w),
            child: Column(
              children: [
                SideBarItems(
                    blueIcon: Assets.home,
                    whiteIcon: Assets.homeWhite,
                    index: 0,
                    items: items,
                    selected: selected,
                    iconSize: 40.w,
                    returnedIndex: (int index) {
                      widget.returnedIndex(index);
                      Navigator.pop(context);
                    },
                    toggleItem: toggleItem),
                SizedBox(
                  height: spaceBetweenItems,
                ),
                SideBarItems(
                    blueIcon: Assets.favorite,
                    whiteIcon: Assets.favoriteWhite,
                    index: 1,
                    items: items,
                    selected: selected,
                    iconSize: 30.w,
                    returnedIndex: (int index) {
                      widget.returnedIndex(index);
                      Navigator.pop(context);
                    },
                    toggleItem: toggleItem),
                SizedBox(
                  height: spaceBetweenItems,
                ),
                SideBarItems(
                    blueIcon: Assets.profile,
                    whiteIcon: Assets.profileWhite,
                    index: 2,
                    items: items,
                    selected: selected,
                    iconSize: 30.w,
                    returnedIndex: (int index) {
                      widget.returnedIndex(index);
                      Navigator.pop(context);
                    },
                    toggleItem: toggleItem),
                SizedBox(
                  height: spaceBetweenItems,
                ),
                SideBarItems(
                    blueIcon: Assets.settings,
                    whiteIcon: Assets.settingsWhite,
                    index: 3,
                    items: items,
                    selected: selected,
                    iconSize: 30.w,
                    returnedIndex: (int index) {},
                    toggleItem: toggleItem),
                SizedBox(
                  height: spaceBetweenItems,
                ),
                const Divider(),
                SizedBox(
                  height: spaceBetweenItems,
                ),
                ListTile(
                  leading: Image.asset(
                    Assets.icSend,
                  ),
                  title: Text(AppStrings.logout,
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp)),
                  onTap: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
