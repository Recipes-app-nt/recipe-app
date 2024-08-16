part of 'social_function_bloc.dart';

abstract class SocialFunctionsState {}

class SocialFunctionsInitial extends SocialFunctionsState {}

class SocialFunctionsLoading extends SocialFunctionsState {}

class SocialFunctionsSuccess extends SocialFunctionsState {
  final bool? isFavoriteAdded;
  final bool? isLikeAdded;
  final String recipeId;

  SocialFunctionsSuccess({
    this.isFavoriteAdded,
    this.isLikeAdded,
    required this.recipeId,
  });
}

class SocialFunctionsFailure extends SocialFunctionsState {
  final String error;

  SocialFunctionsFailure(this.error);
}
