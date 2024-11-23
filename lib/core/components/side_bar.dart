import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/components/side_bar_items.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'package:meal_recommendation_b1/core/utiles/app_colors.dart';
import 'package:meal_recommendation_b1/features/Profile/Presentation/bloc/bloc.dart';
import 'package:meal_recommendation_b1/features/auth/login/domain/entity/user_entity.dart';
import '../../features/auth/login/persentation/bloc/auth_bloc.dart';
import '../../features/auth/login/persentation/bloc/auth_event.dart';
import '../../features/auth/login/persentation/bloc/auth_state.dart';
import '../utiles/app_strings.dart';
import '../utiles/assets.dart';

class SideBar extends StatefulWidget {
  final int oldIndex;
  final Function(int) returnedIndex;
  final AuthBloc authBloc;


  const SideBar({
    super.key,
    required this.oldIndex,
    required this.returnedIndex,
    required this.authBloc,
  });

  @override
  SideBarState createState() => SideBarState();
}

class SideBarState extends State<SideBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.oldIndex;
  }

  // Sidebar Menu Items Configuration
  final List<SidebarMenuItem> _menuItems = [
    SidebarMenuItem(
      title: AppStrings.home,
      activeIcon: Icons.home_rounded,
      inactiveIcon: Icons.home_outlined,
      route: AppRoutes.home,
    ),
    SidebarMenuItem(
      title: AppStrings.favorites,
      activeIcon: Icons.favorite_rounded,
      inactiveIcon: Icons.favorite_border_rounded,
      route: AppRoutes.favorites,
    ),
    SidebarMenuItem(
      title: AppStrings.profile,
      activeIcon: Icons.person_rounded,
      inactiveIcon: Icons.person_outline_rounded,
      route: AppRoutes.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Profile Header
              _buildUserProfileHeader(context),

              // Menu Items
              _buildMenuSection(),

              // Divider
              const Divider(indent: 20, endIndent: 20),

              // Logout Section
              _buildLogoutTile(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileHeader(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          var user = state.user;

          return Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.primary,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  foregroundImage: NetworkImage(user.profilePhoto ??
                      ""), // Assuming profilePhoto is a URL
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ??"",
                      style: const TextStyle(
                          color: AppColors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.email,
                      style: TextStyle(color: AppColors.white.withOpacity(0.7)),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.primary,
            child: Text(
              'User  not logged in',
              style: TextStyle(color: AppColors.white),
            ),
          );
        }
      },
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      child: Column(
        children: _menuItems.map((item) {
          final index = _menuItems.indexOf(item);
          return SideBarItem(
            index: index,
            title: item.title,
            activeIcon: item.activeIcon,
            inactiveIcon: item.inactiveIcon,
            isSelected: _selectedIndex == index,
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.returnedIndex(index);
              Navigator.pop(context);
            },
            activeColor: AppColors.primary,
            inactiveColor: Colors.grey,
            iconSize: 24.w,
            fontSize: 14.sp,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: SideBarItem(
        index: -1,
        // Special index for logout
        title: AppStrings.logout,
        activeIcon: Icons.logout_rounded,
        inactiveIcon: Icons.logout_outlined,
        isSelected: false,
        onTap: () => _showLogoutConfirmDialog(context),
        activeColor: Colors.red,
        inactiveColor: Colors.red.shade300,
        iconSize: 24.w,
        fontSize: 14.sp,
      ),
    );
  }

  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          ElevatedButton(
            onPressed: () {
              widget.authBloc.add(LogoutEvent());
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Updated Menu Item Model
class SidebarMenuItem {
  final String title;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String route;

  SidebarMenuItem({
    required this.title,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.route,
  });
}
