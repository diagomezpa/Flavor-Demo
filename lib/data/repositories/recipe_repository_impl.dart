import 'package:flavorbox/data/models/recipe_model.dart';
import 'package:flavorbox/data/services/json_service.dart';
import 'package:flavorbox/domain/entities/recipe.dart';
import 'package:flavorbox/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final JsonService jsonService;

  RecipeRepositoryImpl(this.jsonService);

  @override
  Future<List<Recipe>> getRecipes() async {
    final recipes = await jsonService.fetchRecipes();
    return recipes;
  }

  Future<Recipe> getRecipe(int id) async {
    final recipe = await jsonService.fetchRecipe(id);
    return recipe;
  }

  @override
  Future<void> addRecipe(Recipe recipe) async {
    final recipeModel = RecipeModel(
      id: recipe.id ?? 0,
      name: recipe.name,
      ingredients: recipe.ingredients,
      description: recipe.description,
    );
    await jsonService.insertRecipe(recipeModel);
  }

  @override
  Future<void> deleteRecipe(int id) async {
    await jsonService.deleteRecipe(id);
  }

  @override
  Future<void> editRecipe(Recipe recipe) async {
    final recipeModel = RecipeModel(
      id: recipe.id ?? 0,
      name: recipe.name,
      ingredients: recipe.ingredients,
      description: recipe.description,
    );
    await jsonService.updateRecipe(recipeModel);
  }
}
