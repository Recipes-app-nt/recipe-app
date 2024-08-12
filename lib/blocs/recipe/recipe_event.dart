import 'package:equatable/equatable.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

abstract class RecipeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadRecipes extends RecipeEvent {}

class AddRecipe extends RecipeEvent {
  final Recipe recipe;

  AddRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class UpdateRecipe extends RecipeEvent {
  final Recipe recipe;

  UpdateRecipe(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class DeleteRecipe extends RecipeEvent {
  final String id;

  DeleteRecipe(this.id);

  @override
  List<Object> get props => [id];
}
