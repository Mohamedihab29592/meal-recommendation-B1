import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/components/loading_dialog.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/Screens/profile_screen.dart';
import 'package:meal_recommendation_b1/features/favorites/presentaion/favorites_view.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeState.dart';
import '../../../../core/components/side_bar.dart';
import '../../../../core/services/di.dart';
import '../../../../core/utiles/app_colors.dart';
import '../../../../core/utiles/assets.dart';
import '../../../Profile/Presentation/bloc/bloc.dart';
import '../../../auth/login/persentation/bloc/auth_bloc.dart';
import '../Cubits/DetailsCubit/DetailsCubit.dart';
import '../Cubits/NavBarCubits/NavBarCubit.dart';
import '../Cubits/NavBarCubits/NavBarState.dart';
import 'HomePage.dart';

class NavBarPage extends StatelessWidget {
   NavBarPage({super.key});

  List<Widget> pages = [
    BlocProvider(
      create: (context) => getIt<HomeCubit>(),
      child: const HomePage(),
    ),
    const FavoritesView(),
    BlocProvider(
      create: (context) => getIt<UserProfileBloc>(),
      child: const ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarCubit, NavBarState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          final user = state.user;
          final authBloc = context.read<AuthBloc>();
          final screenSize = MediaQuery.of(context).size;
          final navBarCubit = BlocProvider.of<NavBarCubit>(context);

          return Scaffold(
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BottomNavigationBar(
                    currentIndex: navBarCubit.currentIndex,
                    items: _buildBottomNavItems(screenSize, navBarCubit),
                    backgroundColor: Colors.white,
                    onTap: (value) {
                      navBarCubit.moveChange(value);
                    },
                  ),
                ),
              ),
              body: pages[navBarCubit.currentIndex],
              drawer: SideBar(
                oldIndex: navBarCubit.currentIndex,
                returnedIndex: (index) {
                  Navigator.of(context).pop();
                  navBarCubit.moveChange(index);
                },
                  user:user,
                authBloc:authBloc
              ));
        } else {
        return    const LoadingDialog(); //issue here
        }
      },
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavItems(
      Size screenSize, NavBarCubit navBarCubit) {
    return [
      _buildBottomNavItem(
          Assets.icHome, navBarCubit.currentIndex == 0, screenSize),
      _buildBottomNavItem(
          Assets.icFavorite, navBarCubit.currentIndex == 1, screenSize),
      _buildBottomNavItem(
          Assets.icAccount, navBarCubit.currentIndex == 2, screenSize),
    ];
  }

  BottomNavigationBarItem _buildBottomNavItem(
      String assetPath, bool isSelected, Size screenSize) {
    return BottomNavigationBarItem(
      icon: isSelected
          ? CircleAvatar(
              radius: screenSize.width < 600 ? 30 : 40,
              backgroundColor: AppColors.primary,
              child: Image.asset(
                assetPath,
                color: Colors.white,
              ),
            )
          : Image.asset(assetPath),
      label: "",
    );
  }
}
