import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/recipe/recipe_event.dart';
import 'package:recipe_app/blocs/recipe/recipe_state.dart';
import 'package:recipe_app/data/repositories/recipe_repository.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final RecipeRepository repository;

  RecipeBloc(this.repository) : super(RecipeLoading()) {
    on<LoadRecipes>(_onLoadRecipes);
    on<AddRecipe>(_onAddRecipe);
    on<UpdateRecipe>(_onUpdateRecipe);
    on<DeleteRecipe>(_onDeleteRecipe);
    on<UploadMedia>(_onUploadMedia);
  }

  void _onLoadRecipes(LoadRecipes event, Emitter<RecipeState> emit) async {
    try {
      final recipes = await repository.getAllRecipes();
      emit(RecipeLoaded(recipes));
    } catch (e) {
      emit(RecipeError("Malumotlarni olishda xatolik mavjud! $e"));
    }
  }

  void _onAddRecipe(AddRecipe event, Emitter<RecipeState> emit) async {
    emit(RecipeLoading());
    try {
       await repository.addRecipe(event.recipe);
      add(LoadRecipes());
    } catch (e) {
      emit(RecipeError("Malumotni qo'shishda xatolik mavjud $e"));
    }
  }

  void _onUpdateRecipe(UpdateRecipe event, Emitter<RecipeState> emit) async {
    try {
      await repository.updateRecipe(event.recipe, event.id);
      add(LoadRecipes());
    } catch (e) {
      emit(RecipeError("Malumotni tahrirlashda xatolik mavjud $e"));
    }
  }

  void _onDeleteRecipe(DeleteRecipe event, Emitter<RecipeState> emit) async {
    try {
      await repository.deleteRecipe(event.id);
      add(LoadRecipes());
    } catch (e) {
      emit(RecipeError("Malumotni o'chirishda xatolik mavjud $e"));
    }
  }

  void _onUploadMedia(UploadMedia event, Emitter<RecipeState> emit) async {
    emit(MediaUploadInProgress());

    try {
      final mediaLink = await repository.uploadMedia(event.path);

      if (mediaLink != null) {
        emit(MediaUploadSuccess(mediaLink, event.mediaType));
      } else {
        emit(MediaUploadFailure("Yuklashda xatolik"));
      }
    } catch (e) {
      emit(MediaUploadFailure("Yuklashda xatolik: $e"));
    }
  }
}
