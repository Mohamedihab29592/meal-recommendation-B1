import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meal_recommendation_b1/core/services/di.dart';
import 'package:meal_recommendation_b1/features/auth/login/persentation/bloc/auth_bloc.dart';
import 'package:meal_recommendation_b1/features/gemini_integrate/persentation/bloc/RecipeBloc.dart';
import 'package:meal_recommendation_b1/features/home/persentation/Cubits/HomeCubit/HomeBloc.dart';
import 'core/utiles/local_storage_service.dart';
import 'firebase_options.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'core/utiles/app_themes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,);
  await Hive.initFlutter();
  LocalStorageService.init();
await setup();
  runApp(const MealApp());
}

class MealApp extends StatelessWidget {
  const MealApp({super.key});
  @override
  Widget build(BuildContext context) {
    return
      DevicePreview(
        builder: (context) =>
            ScreenUtilInit(
              designSize: const Size(375, 812),
              minTextAdapt: true,
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(lazy: true, create: (context) => getIt<RecipeBloc>(),),
                  BlocProvider(lazy: true, create: (context) => getIt<AuthBloc>(),),
                  BlocProvider(lazy: true, create: (context) => getIt<HomeBloc>(),),
                ],
                child: MaterialApp(
                  title: 'Meal - Recommendation',
                  debugShowCheckedModeBanner: false,
                  theme: AppThemes.lightTheme,
                  initialRoute: AppRoutes.splash,
                  onGenerateRoute: AppRoutes.generateRoute,
                ),
              ),
            ),
      );
  }
}