class Category {
  final String name;
  final List<String> recipeIds;

  Category({
    required this.name,
    required this.recipeIds,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] ?? '',
      recipeIds: List<String>.from(json['recipes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'recipes': recipeIds,
    };
  }
}
