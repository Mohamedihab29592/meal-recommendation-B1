import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/core/simple_bloc_observer.dart';
import 'firebase_options.dart';

import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'core/utiles/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setup();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  Bloc.observer = SimpleBlocObserver();
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
        initialRoute: AppRoutes.profile,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
