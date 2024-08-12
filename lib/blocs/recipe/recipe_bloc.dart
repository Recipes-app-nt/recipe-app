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
    try {
      await repository.addRecipe(event.recipe);
      add(LoadRecipes());
    } catch (e) {
      emit(RecipeError("Malumotni qo'shishda xatolik mavjud $e"));
    }
  }

  void _onUpdateRecipe(UpdateRecipe event, Emitter<RecipeState> emit) async {
    try {
      await repository.updateRecipe(event.recipe);
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
}
