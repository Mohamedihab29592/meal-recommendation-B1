import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/gemini_recipe.dart';
import 'firebase_options.dart';


import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'core/utiles/app_themes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
await setup();
  runApp(const MealApp());
}

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
          home: const GeminiRecipe(),
          /*initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,*/
        ),
    );
  }
}


