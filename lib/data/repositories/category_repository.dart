

import 'package:recipe_app/data/models/category_model.dart';
import 'package:recipe_app/data/services/categories_service.dart';

class CategoryRepository {
  final DioCategoryService _dioCategoryService;

  CategoryRepository({required DioCategoryService dioCategoryService})
      : _dioCategoryService = dioCategoryService;

  Future<List<CategoriesModel>> getCategory() async {
    try {
      return _dioCategoryService.getCategories();
    } catch (e) {
      return [];
    }
  }
}
