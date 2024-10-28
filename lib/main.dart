import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/AddRecipesCubit/ImageCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/NavBarCubits/NavBarCubit.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Screens/NavBarPage.dart';
import 'core/utiles/app_themes.dart';
import 'features/home/persentation/Screens/HomePage.dart';
import 'features/on_boarding/screens/on_boarding_screen.dart';

main(){
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MealApp());
}
class MealApp extends StatelessWidget {
  const MealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      builder: (context) =>ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => NavBarCubit(),),
            BlocProvider(create: (context) => ImageCubit(),),
            BlocProvider(create: (BuildContext context) => HomeCubit(),),
          ],
          child: MaterialApp(
            home: OnBoardingScreen(),
            title: 'Meal - Recommendation',
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            // initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.generateRoute,
          ),
        ),
      ),
    );
  }
}


