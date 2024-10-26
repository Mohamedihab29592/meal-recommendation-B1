import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/features/home/persentation/tabs/favorites_view.dart';
import 'package:meal_recommendation_b1/features/home/persentation/tabs/home_view.dart';
import 'package:meal_recommendation_b1/features/home/persentation/tabs/profile_view.dart';
import 'package:meal_recommendation_b1/features/home/persentation/tabs/tab_view/tab_icon.dart';

import '../../../core/utiles/assets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> screens = [const HomeView(), const FavoritesView(), const ProfileView()];
  List<bool> selectedWidgets = [true, false, false];
  int selectScreen = 0;

  void toggleIcon(int index) {
    setState(() {
      for (int i = 0; i < selectedWidgets.length; i++){
        selectedWidgets[i] = false;
      }
      selectedWidgets[index] = true;
      selectScreen = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: bodyContent(context),
      ),
    );
  }

  Widget bodyContent(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      padding: EdgeInsets.symmetric(vertical: 10.h,horizontal: 10.w),
      child: Stack(
        children: [
          screens[selectScreen],
          Positioned(
            top: 20.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){},
                  child: Image.asset(Assets.icProfileMenu),
                ),
                GestureDetector(
                  onTap: (){},
                  child: Image.asset(Assets.icNotification),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 5.h,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width - 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: (){
                      toggleIcon(0);
                    },
                    child: TabIcon(selectedWidgets: selectedWidgets,selectScreen: selectScreen,index: 0,blueIcon: Assets.icHome,whiteIcon: Assets.icHomeWhite,)
                  ),
                  GestureDetector(
                    onTap: (){
                      toggleIcon(1);
                    },
                    child:
                    TabIcon(selectedWidgets: selectedWidgets,selectScreen: selectScreen,index: 1,blueIcon: Assets.icFavorite,whiteIcon: Assets.icFavoriteWhite,)
                  ),
                  GestureDetector(
                    onTap: (){
                      toggleIcon(2);
                    },
                    child:
                    TabIcon(selectedWidgets: selectedWidgets,selectScreen: selectScreen,index: 2,blueIcon: Assets.icAccount,whiteIcon: Assets.icAccountWhite,)
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
