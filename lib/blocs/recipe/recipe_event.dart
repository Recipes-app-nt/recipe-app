// import 'package:equatable/equatable.dart';
// import 'package:recipe_app/data/models/recipe_model.dart';

part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipeEvent {
  final String? categoryId;

   LoadRecipes({ this.categoryId});

  @override
  List<Object> get props => [];
}

class AddRecipe extends RecipeEvent {
  final Recipe recipe;

  AddRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class UpdateRecipe extends RecipeEvent {
  final String id;
  final Recipe recipe;

  UpdateRecipe(this.recipe, this.id);

  @override
  List<Object> get props => [recipe, id];
}

class DeleteRecipe extends RecipeEvent {
  final String id;

  DeleteRecipe(this.id);

  @override
  List<Object> get props => [id];
}

class UploadMedia extends RecipeEvent {
  final String path;
  final String mediaType;

  UploadMedia(this.path, this.mediaType);

  @override
  List<Object> get props => [path, mediaType];
}
