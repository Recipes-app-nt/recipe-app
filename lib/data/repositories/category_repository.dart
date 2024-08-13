

import 'package:recipe_app/data/models/category_model.dart';
import 'package:recipe_app/data/services/categories_service.dart';

class CategoryRepository {
  final DioCategroiesService _dioCategoryService;

  CategoryRepository({required DioCategroiesService dioCategoryService})
      : _dioCategoryService = dioCategoryService;

  Future<List<Category>> getCategory() async {
    try {
      return _dioCategoryService.getCategories();
    } catch (e) {
      return [];
    }
  }
}
