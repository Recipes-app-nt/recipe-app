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
}

// void main(List<String> args) async {
//   SocailFunctionsService recipeService = SocailFunctionsService();
//   try {
//     await recipeService.addComment(
//       "-O47-FV-tElNB9W-eGDf",
//       Comment(
//         userId: "s",
//         text: "Test comment",
//         timestamp: DateTime.now(),
//       ),
//     );
//     // await recipeService.addLike("-O47-FV-tElNB9W-eGDf", 'a');
//     print('Update successful');
//   } catch (e) {
//     print('Main function error: $e');
//   }
// }