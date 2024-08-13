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
      print('Error adding recipe: $e');
      rethrow;
    }
  }

  Future<Recipe> updateRecipe(Recipe recipe, String id) async {
    try {
      final response = await _dioClient.update(
        url: '/recipes/$id.json',
        data: recipe.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to update recipe');
      }

      return Recipe.fromJson(response.data, id);
    } catch (e) {
      print('Error updating recipe: $e');
      rethrow;
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await _dioClient.delete(
        url: '/recipes/$id.json',
      );
    } catch (e) {
      print('Error deleting recipe: $e');
      rethrow;
    }
  }

  Future<Recipe?> getRecipeById(String id) async {
    try {
      final response = await _dioClient.get(
        url: '/recipes/$id.json',
      );
      if (response.data != null) {
        return Recipe.fromJson(response.data, id);
      }
      return null;
    } catch (e) {
      print('Error getting recipe by ID: $e');
      rethrow;
    }
  }

  Future<List<Recipe>> getAllRecipes() async {
    try {
      final response = await _dioClient.get(
        url: '/recipes.json',
      );
      if (response.data != null) {
        List<Recipe> recipes = [];
        final Map<String, dynamic> data = response.data;

        data.forEach(
          (key, value) {
            value['id'] = key;
            recipes.add(Recipe.fromJson(value, key));
          },
        );
        return recipes;
      }
      return [];
    } catch (e) {
      print('Error getting all recipes: $e');
      rethrow;
    }
  }
}

// void main(List<String> args) async {
//   RecipeService recipeService = RecipeService();
//   try {
//     final res = await recipeService.getAllRecipes();
//     print(res);
//     print('Update successful');
//   } catch (e) {
//     print('Main function error: $e');
//   }
// }
