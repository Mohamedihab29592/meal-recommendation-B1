import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal_recommendation_b1/features/auth/OTP/presentation/phone_bloc/phone_bloc.dart';
import 'package:meal_recommendation_b1/features/auth/register/persentation/bloc/register_bloc.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/AddRecipesCubit/add_ingredient_cubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeEvent.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Screens/AddRecipes.dart';
import 'package:meal_recommendation_b1/features/welcome/welcome_screen.dart';
import '../../features/auth/OTP/presentation/screens/otp.dart';
import '../../features/auth/login/persentation/bloc/auth_bloc.dart';
import '../../features/auth/login/persentation/screens/login/login_screen.dart';
import '../../features/auth/register/persentation/screens/register/register_screen.dart';
import '../../features/gemini_integrate/persentation/bloc/RecipeBloc.dart';
import '../../features/gemini_integrate/persentation/gemini_recipe.dart';
import '../../features/home/persentation/Cubits/DetailsCubit/DetailsCubit.dart';
import '../../features/home/persentation/Cubits/HomeCubit/HomeCubit.dart';
import '../../features/home/persentation/Cubits/NavBarCubits/NavBarCubit.dart';
import '../../features/home/persentation/Screens/Details/DetailsPage.dart';
import '../../features/home/persentation/Screens/HomePage.dart';
import '../../features/home/persentation/Screens/NavBarPage.dart';
import '../../features/home/persentation/Screens/see_all_page.dart';
import '../../features/on_boarding/screens/on_boarding_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../services/di.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String welcome = '/welcome';
  static const String verification = '/verification';
  static const String home = '/home';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String details = '/details';
  static const String seeAll = '/seeAll';
  static const String addIngredients = '/addIngredients';
  static const String otp = '/addIngredients';
  static const String navBar = '/NavBar';
  static const String detailsPage = '/detailsPage';
  static const String addRecipes = '/addRecipes';
  static const String geminiRecipe = '/geminiRecipe';

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
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(providers: [
                  BlocProvider(
                    create: (context) => getIt<RegisterBloc>(),
                  ),

                  BlocProvider(
                    create: (context) => getIt<PhoneAuthBloc>(),
                  )
                ], child: const RegisterScreen()));
      case otp:
        return MaterialPageRoute(builder: (_) => const OTPView());
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomePage());
      case geminiRecipe:
        return MaterialPageRoute(
            builder: (_) => const GeminiRecipePage());
      case home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => getIt<HomeBloc>(),
            child: const HomePage(),
          ),

        );
      case navBar:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<NavBarCubit>()..fetchCurrentUser(),
                  child:   NavBarPage(),
                ));

      case detailsPage:
        final String recipeId = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => getIt<DetailsCubit>(),
                  child: DetailsPage(recipeId: recipeId),
                ));
      case addRecipes:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) => getIt<AddIngredientCubit>(), child: AddRecipes()));
      case seeAll:
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (_) => getIt<HomeBloc>()..add(FetchRecipesEvent()),
                child: const SeeAllScreen()));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
