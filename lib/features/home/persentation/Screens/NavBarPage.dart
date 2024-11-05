import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/favorites/presentaion/favorites_view.dart';
import '../../../../core/utiles/app_colors.dart';
import '../../../../core/utiles/assets.dart';
import '../Cubits/NavBarCubits/NavBarCubit.dart';
import '../Cubits/NavBarCubits/NavBarState.dart';
import 'HomePage.dart';

class NavBarPage extends StatelessWidget {
  NavBarPage({super.key});

  // Main pages list
  List<Widget> pages = [
    HomePage(),
    FavoritesView(),
    Center(child: Text("profile")),
  ];

  AppColors appcolor = AppColors();
  Assets asset = Assets();

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
  create: (context) => NavBarCubit(),
  child: BlocConsumer<NavBarCubit, NavBarState>(
        listener: (context, state) {},
        builder: (context, state) {
          final screenSize = MediaQuery.of(context).size;

          return Scaffold(
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
              ),
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  currentIndex: BlocProvider.of<NavBarCubit>(context).currentIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: BlocProvider.of<NavBarCubit>(context).currentIndex == 0
                          ? CircleAvatar(
                        radius: screenSize.width < 600 ? 30 : 40,
                        backgroundColor: AppColors.primary,
                        child: Image.asset(
                          "${Assets.icHome}",
                          color: Colors.white,
                        ),
                      )
                          : Image.asset("${Assets.icHome}"),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: BlocProvider.of<NavBarCubit>(context).currentIndex == 1
                          ? CircleAvatar(
                        radius: screenSize.width < 600 ? 30 : 40,
                        backgroundColor: AppColors.primary,
                        child: Image.asset(
                          "${Assets.icFavorite}",
                          color: Colors.white,
                        ),
                      )
                          : Image.asset("${Assets.icFavorite}"),
                      label: "",
                    ),
                    BottomNavigationBarItem(
                      icon: BlocProvider.of<NavBarCubit>(context).currentIndex == 2
                          ? CircleAvatar(
                        radius: screenSize.width < 600 ? 30 : 40,
                        backgroundColor: AppColors.primary,
                        child: Image.asset(
                          "${Assets.icAccount}",
                          color: Colors.white,
                        ),
                      )
                          : Image.asset("${Assets.icAccount}"),
                      label: "",
                    ),
                  ],
                  backgroundColor: Colors.white,
                  onTap: (value) {
                    BlocProvider.of<NavBarCubit>(context).moveChange(value);
                  },
                ),
              ),
            ),
            body: pages[BlocProvider.of<NavBarCubit>(context).currentIndex],
          );
        },
    ),
);
  }
}
