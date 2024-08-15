// part of 'social_function_bloc.dart';

// abstract class SocialFunctionsState {}

// class SocialFunctionsInitial extends SocialFunctionsState {}

// class SocialFunctionsLoading extends SocialFunctionsState {}

// class SocialFunctionsSuccess extends SocialFunctionsState {}

// class SocialFunctionsFailure extends SocialFunctionsState {
//   final String error;

//   SocialFunctionsFailure(this.error);
// }


part of 'social_function_bloc.dart';

abstract class SocialFunctionsState {}

class SocialFunctionsInitial extends SocialFunctionsState {}

class SocialFunctionsLoading extends SocialFunctionsState {}

class SocialFunctionsSuccess extends SocialFunctionsState {
  final bool isFavoriteAdded;
  final String recipeId;

  SocialFunctionsSuccess(
      {required this.isFavoriteAdded, required this.recipeId});
}

class SocialFunctionsFailure extends SocialFunctionsState {
  final String error;

  SocialFunctionsFailure(this.error);
}
