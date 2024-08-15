import 'package:hive/hive.dart';
part 'recipe_model.g.dart';

@HiveType(typeId: 0)
class Recipe extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  List<String> ingredients;

  @HiveField(3)
  List<String> instructions;

  @HiveField(4)
  String cookingTime;

  @HiveField(5)
  String imageUrl;

  @HiveField(6)
  String videoUrl;

  @HiveField(7)
  String category;

  @HiveField(8)
  String authorId;

  @HiveField(9)
  double rating;

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.cookingTime,
    required this.imageUrl,
    required this.videoUrl,
    required this.category,
    required this.authorId,
    required this.rating,
  });
}
