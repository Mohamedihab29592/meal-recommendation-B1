 import 'package:flutter/material.dart';
import 'package:meal_recommendation_b1/core/routes/app_routes.dart';
import 'package:meal_recommendation_b1/core/utiles/extentions.dart';

import '../../core/services/di.dart';
import '../auth/domain/entity/user_entity.dart';
import '../auth/domain/repository/auth_repository.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = getIt<AuthRepository>();

    return FutureBuilder<UserEntity?>(
      future: authRepository.getSavedUser(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Loading state
        } else {
          if (snapshot.data != null) {
            // User is already logged in
            Future.microtask(() {
              context.replaceWith(AppRoutes.home);
            });
          } else {
            // User is not logged in
            Future.microtask(() {
              context.replaceWith(AppRoutes.login);
            });
          }
        }
        return Container(); // Empty container while navigating
      },
    );
  }
}
