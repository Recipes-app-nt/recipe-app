import 'comment_model.dart';

class Recipe {
  final String id;
  final String title;
  final List<String> ingredients;
  final List<String> instructions;
  final String cookingTime;
  final String imageUrl;
  final String videoUrl;
  final String category;
  final String authorId;
  final Map<String, bool> likes;
  final Map<String, Comment> comments;
  final DateTime createdAt;
  final DateTime updatedAt;

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
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json, String id) {
    return Recipe(
      id: id,
      title: json['title'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      cookingTime: json['cooking_time'] ?? '',
      imageUrl: json['image_url'] ?? '',
      videoUrl: json['video_url'] ?? '',
      category: json['category'] ?? '',
      authorId: json['author_id'] ?? '',
      likes: Map<String, bool>.from(json['likes'] ?? {}),
      comments: (json['comments'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(key, Comment.fromJson(value))),
      createdAt:
          DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt:
          DateTime.parse(json['updated_at'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'cooking_time': cookingTime,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'category': category,
      'author_id': authorId,
      'likes': likes,
      'comments':
          comments.map((key, comment) => MapEntry(key, comment.toJson())),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
