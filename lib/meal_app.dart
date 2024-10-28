import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'core/services/di.dart';
import 'features/home/favorites/data/models/favorites.dart';
import 'firebase_options.dart';
import 'package:device_preview/device_preview.dart';
import 'main.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(FavoritesAdapter());
  final favoriteBox = await Hive.openBox<Favorites>('favorites');

  await setup(favoriteBox);

  runApp(DevicePreview(builder: (context) => const MealApp()));
  // runApp(const MealApp());
}
