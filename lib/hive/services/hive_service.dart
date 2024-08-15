import 'package:hive/hive.dart';
import 'package:recipe_app/hive/models/recipe_hive_model.dart';

class RecipeHiveService {
  Box<RecipeHiveModel>? _recipeBox;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(RecipeAdapter());
    }
    _recipeBox = await Hive.openBox<RecipeHiveModel>('recipeBox');
  }

  Future<void> addRecipe(RecipeHiveModel recipe) async {
    await _ensureInitialized();
    await _recipeBox!.add(recipe);
  }

  RecipeHiveModel? getRecipe(String id) {
    _ensureInitialized();
    return _recipeBox?.get(id);
  }

  Future<void> updateRecipe(RecipeHiveModel recipe) async {
    await _ensureInitialized();
    await _recipeBox!.put(recipe.id, recipe);
  }

  Future<void> deleteRecipe(String id) async {
    await _ensureInitialized();
    await _recipeBox!.delete(id);
  }

  List<RecipeHiveModel> getAllRecipes() {
    _ensureInitialized();
    return _recipeBox?.values.toList() ?? [];
  }

  Future<void> _ensureInitialized() async {
    if (_recipeBox == null) {
      await init();
    }
  }
}