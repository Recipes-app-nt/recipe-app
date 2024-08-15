import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/network/dio_client.dart';
import '../../hive/services/hive_service.dart';

class RecipeService {
  final _dioClient = DioClient();
  final recipeHiveService = RecipeHiveService();

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
    try {
      final response = await _dioClient.update(
        url: '/recipes/$id.json',
        data: recipe.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Ma'lumotni tahrirlashda xatolik!!!");
      }

      return Recipe.fromJson(response.data, id);
    } catch (e) {
      print("Xatolik $e");
      rethrow;
    }
  }

  Future<void> deleteRecipe(String id) async {
    try {
      await _dioClient.delete(
        url: '/recipes/$id.json',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Recipe>> getUserRecipes() async {
    try {
      final response = await _dioClient.get(
        url: 'recipes.json',
      );
      final Map<String, dynamic> mapData = response.data;

      List<Recipe> recipes = [];

      final prefs = await SharedPreferences.getInstance();

      final userData = jsonDecode(prefs.getString("userData")??"");

      String email = userData['email'];
      print(email);

      for (final key in mapData.keys) {
        final value = mapData[key];
        print(value['author_id']);
        if (value['author_id'] == email) {
          recipes.add(Recipe.fromJson(value, key));
        }
      }
      return recipes;
    } on DioException {
      rethrow;
    } catch (e) {
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
      rethrow;
    }
  }
}
