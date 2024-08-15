part of 'social_function_bloc.dart';

abstract class SocialFunctionsEvent {}

class AddCommentEvent extends SocialFunctionsEvent {
  final String recipeId;
  final Comment comment;

  AddCommentEvent(this.recipeId, this.comment);
}

class AddLikeEvent extends SocialFunctionsEvent {
  final String recipeId;
  final String userId;

  AddLikeEvent(this.recipeId, this.userId);
}

class AddFavoriteEvent extends SocialFunctionsEvent {
  final String recipeId;
  final String userId;

  AddFavoriteEvent(this.recipeId, this.userId);
}

class RemoveFavoriteEvent extends SocialFunctionsEvent {
  final String recipeId;
  final String userId;

  RemoveFavoriteEvent(this.recipeId, this.userId);
}
