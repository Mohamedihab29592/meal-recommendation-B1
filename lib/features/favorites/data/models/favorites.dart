import 'package:hive/hive.dart';

part 'favorites.g.dart';

@HiveType(typeId: 0)
class Favorites {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String subTitle;

  @HiveField(3)
  final String ingredients;

  @HiveField(4)
  final String timing;

  @HiveField(5)
  final double rating;

  @HiveField(6)
  final String image;

  Favorites({required this.id, required this.title, required this.subTitle, required this.ingredients, required this.timing, required this.rating, required this.image});
}