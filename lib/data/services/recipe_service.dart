import 'package:dio/dio.dart';
import 'package:recipe_app/data/models/comment_model.dart';
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
        final recipes = <Recipe>[];
        final Map<String, dynamic> data = response.data;

        data.forEach((id, json) {
          json['id'] = id;
          recipes.add(Recipe.fromJson(json, id));
        });
        return recipes;
      }
      return [];
    } catch (e) {
      print('Error getting all recipes: $e');
      rethrow;
    }
  }

  Future<void> addComment(String recipeId, Comment comment) async {
    try {
      final response = await _dioClient.get(
        url: '/recipes/$recipeId.json',
      );

      if (response.data == null) {
        throw Exception('Recipe not found');
      }

      final dynamic commentsData = response.data['comments'];
      final List<dynamic> commentList =
          commentsData is List<dynamic> ? List<dynamic>.from(commentsData) : [];

      final newComment = comment.toJson();
      commentList.add(newComment);

      final updateResponse = await _dioClient.update(
        url: '/recipes/$recipeId.json',
        data: {'comments': commentList},
      );

      if (updateResponse.statusCode != 200 &&
          updateResponse.statusCode != 201) {
        throw Exception('Failed to update comments');
      }

      print('Comment added successfully');
    } on DioException catch (e) {
      print('Error adding comment: $e');
      rethrow;
    } catch (e) {
      print('Error adding comment: $e');
      rethrow;
    }
  }



  Future<void> addLike(String recipeId, String userId) async {
    try {
      final response = await _dioClient.get(
        url: '/recipes/$recipeId.json',
      );

      if (response.data == null) {
        throw Exception('Recipe not found');
      }

      final likes = response.data['likes'];
      List<String> updatedLikes = [];

      if (likes is List) {
        updatedLikes = List<String>.from(likes);
      }

      if (!updatedLikes.contains(userId)) {
        updatedLikes.add(userId);
      }

      final updateResponse = await _dioClient.update(
        url: '/recipes/$recipeId.json',
        data: {'likes': updatedLikes},
      );

      if (updateResponse.statusCode != 200 &&
          updateResponse.statusCode != 201) {
        throw Exception('Failed to update likes');
      }

      print('Like added successfully');
    } on DioException catch (e) {
      print('Error adding like: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Error adding like: $e');
      rethrow;
    }
  }
}

// void main(List<String> args) async {
//   RecipeService recipeService = RecipeService();
//   try {
//     await recipeService.addComment(
//       "-O47-FV-tElNB9W-eGDf",
//       Comment(
//         userId: "s",
//         text: "Yangi comment",
//         timestamp: DateTime.now(),
//       ),
//     );
//     // await recipeService.addLike("-O47-FV-tElNB9W-eGDf", 'a');
//     print('Update successful');
//   } catch (e) {
//     print('Main function error: $e');
//   }
// }
