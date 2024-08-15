import 'package:hive/hive.dart';
import 'package:recipe_app/hive/models/recipe_model.dart';

class RecipeHiveService {
  late Box<Recipe> recipeBox;

  RecipeHiveService() {
    _init();
  }

  Future<void> _init() async {
    Hive.registerAdapter(RecipeAdapter());

    recipeBox = await Hive.openBox<Recipe>('recipeBox');
  }

  Future<void> addRecipe(Recipe recipe) async {
    await recipeBox.add(recipe);
  }

  Recipe? getRecipe(String id) {
    return recipeBox.get(id);
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await recipeBox.put(recipe.id, recipe);
  }

  Future<void> deleteRecipe(String id) async {
    await recipeBox.delete(id);
  }

  List<Recipe> getAllRecipes() {
    return recipeBox.values.toList();
  }
}
