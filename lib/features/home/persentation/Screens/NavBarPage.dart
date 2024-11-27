import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/core/components/loading_dialog.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/Screens/profile_screen.dart';
import 'package:meal_recommendation_b1/features/favorites/presentaion/favorites_view.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeBloc.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeState.dart';
import '../../../../core/components/Custome_Appbar.dart';
import '../../../../core/components/side_bar.dart';
import '../../../../core/routes/app_routes.dart';
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

  final List<Widget> pages = [
    BlocProvider.value(value: getIt<HomeBloc>(), child: const HomePage()),
    BlocProvider.value(value: getIt<HomeBloc>(), child: const FavoritesView()),
    BlocProvider(
      create: (context) => getIt<UserProfileBloc>(),
      child: const ProfileScreen(),
    ),
  ];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AuthBloc>(),
      child: BlocBuilder<NavBarCubit, NavBarState>(
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
              key: _scaffoldKey,
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                      child: CustomAppbar(
                        rightPadding: 0,
                        leftPadding: 0,
                        ontapleft: () {
                          _scaffoldKey.currentState?.openDrawer(); // Open the drawer
                        },
                        ontapright: () {
                          context.pushNamed(AppRoutes.geminiRecipe);
                        },
                        leftImage: Assets.icProfileMenu,
                      ),
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: navBarCubit.currentIndex,
                        children: pages,
                      ),
                    ),
                  ],
                ),
              ),
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
              drawer: SideBar(user: user, authBloc: authBloc),
            );
            ;
          } else {
            return const Center(child: Text('Unexpected state.'));
          }
        },
      ),
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
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: isSelected ? 50 : 40,
        width: isSelected ? 50 : 40,
        child: CircleAvatar(
          radius: isSelected ? 30 : 20,
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
