import 'package:flavorbox/domain/entities/recipe.dart';

abstract class RecipeRepository {
  Future<List<Recipe>> getRecipes();
  Future<void> addRecipe(Recipe recipe);
  Future<void> deleteRecipe(int id);
  Future<void> editRecipe(Recipe recipe);
}
