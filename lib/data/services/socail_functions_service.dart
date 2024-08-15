import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../models/comment_model.dart';

class SocailFunctionsService {
  final _dioClient = DioClient();

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

  Future<void> addFavorite(String recipeId, String userId) async {
    try {
      final response = await _dioClient.get(
        url: '/users/$userId.json',
      );

      if (response.data == null) {
        throw Exception('User not found');
      }

      final favorites = response.data['favoriteDishes'];
      List<String> updateFavorites = [];

      if (favorites is List) {
        updateFavorites = List<String>.from(favorites);
      }

      if (!updateFavorites.contains(recipeId)) {
        updateFavorites.add(recipeId);
      }

      final updateResponse = await _dioClient.update(
        url: '/users/$userId.json',
        data: {'favoriteDishes': updateFavorites},
      );

      if (updateResponse.statusCode != 200 &&
          updateResponse.statusCode != 201) {
        throw Exception('Failed to update favoriteDishes');
      }

      print('Recipe added to favorites successfully');
    } on DioException catch (e) {
      print('Error adding favorite: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Error adding favorite: $e');
      rethrow;
    }
  }

  Future<void> removeFavorite(String recipeId, String userId) async {
    try {
      final response = await _dioClient.get(
        url: '/users/$userId.json',
      );

      if (response.data == null) {
        throw Exception('User not found');
      }

      final favorites = response.data['favoriteDishes'];
      List<String> updateFavorites = [];

      if (favorites is List) {
        updateFavorites = List<String>.from(favorites);
      }

      updateFavorites.remove(recipeId);

      final updateResponse = await _dioClient.update(
        url: '/users/$userId.json',
        data: {'favoriteDishes': updateFavorites},
      );

      if (updateResponse.statusCode != 200 &&
          updateResponse.statusCode != 201) {
        throw Exception('Failed to update favoriteDishes');
      }

      print('Recipe removed from favorites successfully');
    } on DioException catch (e) {
      print('Error removing favorite: ${e.response?.data}');
      rethrow;
    } catch (e) {
      print('Error removing favorite: $e');
      rethrow;
    }
  }
}

// void main(List<String> args) async {
//   SocailFunctionsService recipeService = SocailFunctionsService();
//   try {
//     // await recipeService.addComment(
//     //   "-O4GbfFDcTmIYR6D4bAB",
//     //   Comment(
//     //     userId: "-O4GmgBLFYb545_nuSmp",
//     //     text: "Salom test comment",
//     //     timestamp: DateTime.now(),
//     //   ),
//     // );
//     // await recipeService.addFavorite("-O4GbfFDcTmIYR6D4bAB", '-O4H67gKcKWL151iNuDy');
//   //  await recipeService.removeFavorite("-O4GbfFDcTmIYR6D4bAB", "-O4H67gKcKWL151iNuDy");
//     print('Update successful');
//   } catch (e) {
//     print('Main function error: $e');
//   }
// }
