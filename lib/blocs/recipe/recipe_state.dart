import 'package:equatable/equatable.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

abstract class RecipeState extends Equatable {
  @override
  List<Object> get props => [];
}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;

  RecipeLoaded(this.recipes);

  @override
  List<Object> get props => [recipes];
}

class RecipeError extends RecipeState {
  final String message;

  RecipeError(this.message);

  @override
  List<Object> get props => [message];
}

/// Mediani yuklayotganda Isolateni ko'rsatish uchun
class MediaUploadInProgress extends RecipeState {}

/// Media yuklanib bo'landan so'ng
class MediaUploadSuccess extends RecipeState {
  final String downloadUrl;

  MediaUploadSuccess(this.downloadUrl);

  @override
  List<Object> get props => [downloadUrl];
}

/// Media yuklashda xatolik yuz bersa
class MediaUploadFailure extends RecipeState {
  final String message;

  MediaUploadFailure(this.message);

  @override
  List<Object> get props => [message];
}
