import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/components/loading_dialog.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/Screens/profile_screen.dart';
import 'package:meal_recommendation_b1/features/favorites/presentaion/favorites_view.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeBloc.dart';
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
    BlocProvider.value(value: getIt<HomeBloc>(), child: const HomePage()),
    BlocProvider.value(value: getIt<HomeBloc>(), child: const FavoritesView()),
    BlocProvider(
      create: (context) => getIt<UserProfileBloc>(),
      child: const ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarCubit, NavBarState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const LoadingDialog();
        } else if (state is UserFetchError) {
          return Center(child: Text(state.errorMessage));
        } else if (state is UserLoaded) {
          final user = state.user;
          final authBloc = context.read<AuthBloc>();
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
                  items: _buildBottomNavItems(navBarCubit),
                  backgroundColor: Colors.white,
                  onTap: (value) {
                    navBarCubit.moveChange(value);
                  },
                ),
              ),
            ),
            body: pages[navBarCubit.currentIndex],
            drawer: SideBar(user: user, authBloc: authBloc),
          );
        } else {
          return const Center(child: Text('Unexpected state.'));
        }
      },
    );
  }

  List<BottomNavigationBarItem> _buildBottomNavItems(NavBarCubit navBarCubit) {
    return [
      _buildBottomNavItem(Assets.icHome, navBarCubit.currentIndex == 0),
      _buildBottomNavItem(Assets.icFavorite, navBarCubit.currentIndex == 1),
      _buildBottomNavItem(Assets.icAccount, navBarCubit.currentIndex == 2),
    ];
  }

  BottomNavigationBarItem _buildBottomNavItem(String assetPath, bool isSelected) {
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeInOut, // Animation curve
        height: isSelected ? 50 : 40, // Height change for animation
        width: isSelected ? 50 : 40, // Width change for animation
        child: CircleAvatar(
          radius: isSelected ? 30 : 20, // Circle size change
          backgroundColor: isSelected ? AppColors.primary : Colors.transparent,
          child: Image.asset(
            assetPath,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
        ),
      ),
      label: "",
    );
  }
}