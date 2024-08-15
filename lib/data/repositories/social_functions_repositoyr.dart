import '../models/comment_model.dart';
import '../services/socail_functions_service.dart';

abstract class SocialFunctionsRepositoryAbs {
  Future<void> addComment(String recipeId, Comment comment);
  Future<void> addLike(String recipeId, String userId);
  Future<void> addFavorite(String recipeId, String userId);
  Future<void> removeFavorite(String recipeId, String userId);
}

class SocialFunctionsRepository implements SocialFunctionsRepositoryAbs {
  final SocailFunctionsService socialFunctionsService;

  SocialFunctionsRepository({required this.socialFunctionsService});

  @override
  Future<void> addComment(String recipeId, Comment comment) async {
    try {
      await socialFunctionsService.addComment(recipeId, comment);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addLike(String recipeId, String userId) async {
    try {
      await socialFunctionsService.addLike(recipeId, userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addFavorite(String recipeId, String userId) async {
    try {
      await socialFunctionsService.addFavorite(recipeId, userId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFavorite(String recipeId, String userId) async {
    try {
      await socialFunctionsService.removeFavorite(recipeId, userId);
    } catch (e) {
      rethrow;
    }
  }
}
