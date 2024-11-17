import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/components/side_bar_items.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import '../../features/Profile/Presentation/bloc/bloc.dart';
import '../../features/Profile/Presentation/bloc/event.dart';
import '../../features/Profile/Presentation/bloc/state.dart';
import '../../features/Profile/domain/entity/entity.dart';
import '../services/di.dart';
import '../utiles/app_strings.dart';
import '../utiles/assets.dart';

class SideBar extends StatefulWidget {
  final int oldIndex;
  final Function returnedIndex;
  const SideBar(
      {super.key, required this.oldIndex, required this.returnedIndex});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  double spaceBetweenItems = 30.h;

  String username = "";

  List items = [
    AppStrings.home,
    AppStrings.favorites,
    AppStrings.profile,
    AppStrings.settings
  ];
  List selected = [true, false, false, false];
  int selectItem = 0;

  String imageUrl = '';
  bool loading = true;

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<UserProfileBloc>()..add(LoadUserProfile('9uXQoT0sMkfqwhqevcJpfhJSEbm1')),
      child: BlocConsumer<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
        if (state is UserProfileLoaded) {
          username = state.user.name;
          imageUrl = state.user.profilePhotoUrl ?? '';
          loading = false;
        } else if (state is UserProfileLoading) {
          loading = true;
        } else if (state is UserProfileError) {
          loading = false;
          customSnackBar(context, message: state.message);
        }
      }, builder: (context, state) {
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
                  child: loading
                      ? const CircularProgressIndicator()
                      : Row(
                          children: [
                            imageUrl == ""
                                ? CircleAvatar(
                                    radius: MediaQuery.of(context).size.height *
                                        0.075,
                                    foregroundImage: const AssetImage(
                                      Assets.icSplash,
                                    ))
                                : CircleAvatar(
                                    radius: MediaQuery.of(context).size.height *
                                        0.075,
                                    backgroundColor: const Color(0xffD9D9D9),
                                    child: ClipOval(
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Text(username,
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
      }),
    );
  }
}
