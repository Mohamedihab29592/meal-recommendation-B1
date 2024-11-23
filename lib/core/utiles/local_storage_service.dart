
import 'package:hive/hive.dart';

class LocalStorageService {
  static const String favoritesBox = 'favorites';

  // Open the favorites box
  static Future<void> init() async {
    await Hive.openBox<String>(favoritesBox);
  }

  static Box<String> getFavoritesBox() => Hive.box<String>(favoritesBox);
}