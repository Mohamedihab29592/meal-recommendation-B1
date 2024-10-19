import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'core/utiles/app_themes.dart';
import 'features/splash/splash_screen.dart';


class MealApp extends StatelessWidget {
  const MealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'Meal - Recommendation',
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}


