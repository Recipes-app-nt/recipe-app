import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:recipe_app/data/services/recipe_service.dart';

class RecipeRepository {
  final _recipeService = RecipeService();

  Future<void> addRecipe(Recipe recipe) async {
    await _recipeService.addRecipe(recipe);
  }

  Future<void> updateRecipe(Recipe recipe, String id) async {
    await _recipeService.updateRecipe(recipe, id);
  }

  Future<void> deleteRecipe(String id) async {
    await _recipeService.deleteRecipe(id);
  }

  Future<Recipe?> getRecipeById(String id) async {
    return await _recipeService.getRecipeById(id);
  }

  Future<List<Recipe>> getAllRecipes() async {
    return await _recipeService.getAllRecipes();
  }
}
