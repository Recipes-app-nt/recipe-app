import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:recipe_app/data/services/image_service.dart';
import 'package:recipe_app/data/services/recipe_service.dart';

class RecipeRepository {
  final _recipeService = RecipeService();
  final imageService = ImageService();

  Future<void> addRecipe(Recipe recipe) async {
    await _recipeService.addRecipe(recipe);
  }

  Future<void> updateRecipe(Recipe recipe, String id) async {
    await _recipeService.updateRecipe(recipe, id);
  }

  Future<List<Recipe>> getRecipeById(String id) async {
    return await _recipeService.getRecipeById(id);
  }

  Future<void> deleteRecipe(String id) async {
    await _recipeService.deleteRecipe(id);
  }

  Future<List<Recipe>> getUserRecipes() async {
    return await _recipeService.getUserRecipes();
  }

  Future<List<Recipe>> getAllRecipes() async {
    return await _recipeService.getAllRecipes();
  }

  Future<String?> uploadMedia(String filePath, String mediaType) async {
    return await imageService.uploadMedia(filePath, mediaType: mediaType);
  }
}
