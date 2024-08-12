import 'package:dio/dio.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

class RecipeService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://your-firebase-url.firebaseio.com';

  Future<void> addRecipe(Recipe recipe) async {
    await _dio.post('$_baseUrl/recipes/${recipe.id}.json',
        data: recipe.toJson());
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _dio.put('$_baseUrl/recipes/${recipe.id}.json',
        data: recipe.toJson());
  }

  Future<void> deleteRecipe(String id) async {
    await _dio.delete('$_baseUrl/recipes/$id.json');
  }

  Future<Recipe?> getRecipeById(String id) async {
    final response = await _dio.get('$_baseUrl/recipes/$id.json');
    if (response.data != null) {
      return Recipe.fromJson(response.data, id);
    }
    return null;
  }

  Future<List<Recipe>> getAllRecipes() async {
    final response = await _dio.get('$_baseUrl/recipes.json');
    if (response.data != null) {
      final recipes = <Recipe>[];
      final data = response.data as Map<String, dynamic>;
      data.forEach((id, json) {
        recipes.add(Recipe.fromJson(json, id));
      });
      return recipes;
    }
    return [];
  }
}
