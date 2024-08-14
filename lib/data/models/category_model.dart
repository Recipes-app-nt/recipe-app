class CategoriesModel {
  final String id;
  final String name;
  final String categoryId;

  CategoriesModel(
      {required this.id, required this.name, required this.categoryId});

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        categoryId: json['categoryId'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryId': categoryId,
    };
  }
}
