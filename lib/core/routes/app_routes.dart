import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/login/persentation/bloc/auth_bloc.dart';
import '../../features/auth/login/persentation/screens/login/login_screen.dart';
import '../../features/auth/register/register_screen.dart';
import '../../features/on_boarding/screens/on_boarding_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../services/di.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String verification = '/verification';
  static const String home = '/home';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String details = '/details';
  static const String seeAll = '/seeAll';
  static const String addIngredients = '/addIngredients';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());

      case login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
              create: (_) => getIt<AuthBloc>(), child: const LoginScreen()),
        );
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case verification:
      //return MaterialPageRoute(builder: (_) => VerificationScreen());
      case home:
      //return MaterialPageRoute(builder: (_) => HomeScreen());
      case favorites:
      //return MaterialPageRoute(builder: (_) => FavoritesScreen());
      case profile:
      //return MaterialPageRoute(builder: (_) => ProfileScreen());
      case details:
      // return MaterialPageRoute(builder: (_) => DetailsScreen());
      case seeAll:
      // return MaterialPageRoute(builder: (_) => SeeAllScreen());
      case addIngredients:
      // return MaterialPageRoute(builder: (_) => AddIngredientsScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
