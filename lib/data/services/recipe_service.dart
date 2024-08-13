import 'package:recipe_app/data/models/recipe_model.dart';

import '../../core/network/dio_client.dart';

class RecipeService {
  final _dioClient = DioClient();

  Future<Recipe> addRecipe(Recipe recipe) async {
    try {
      final response = await _dioClient.add(
        url: "/recipes.json",
        data: recipe.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Qo'shishda xatolik!!!");
      }

      final data = response.data;
      final recipeId = data['name'];
      recipe.id = recipeId;

      return Recipe.fromJson(
        data,
        recipeId,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Recipe> updateRecipe(Recipe recipe, String id) async {
   final response = await _dioClient.update(
      url: '/recipes/$id.json',
      data: recipe.toJson(),
    );

    return Recipe.fromJson(response.data, id);
  }

  Future<void> deleteRecipe(String id) async {
    await _dioClient.delete(
      url: '/recipes/$id.json',
    );
  }

  Future<Recipe?> getRecipeById(String id) async {
    final response = await _dioClient.get(
      url: '/recipes/$id.json',
    );
    if (response.data != null) {
      return Recipe.fromJson(response.data, id);
    }
    return null;
  }

  Future<List<Recipe>> getAllRecipes() async {
    final response = await _dioClient.get(
      url: '/recipes.json',
    );
    if (response.data != null) {
      final recipes = <Recipe>[];
      final Map<String, dynamic> data = response.data;

      data.forEach((id, json) {
        json['id'] = id;
        recipes.add(Recipe.fromJson(json, id));
      });
      return recipes;
    }
    return [];
  }
}