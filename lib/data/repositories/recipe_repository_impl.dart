import 'package:flavorbox/data/models/recipe_model.dart';
import 'package:flavorbox/data/services/databaseHelper.dart';
import 'package:flavorbox/domain/entities/recipe.dart';
import 'package:flavorbox/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final DatabaseHelper databaseHelper;

  RecipeRepositoryImpl(this.databaseHelper);

  @override
  Future<List<Recipe>> getRecipes() async {
    final recipes = await databaseHelper.fetchRecipes();
    return recipes;
  }

  @override
  Future<void> addRecipe(Recipe recipe) async {
    final recipeModel = RecipeModel(
      id: recipe.id ?? 0,
      name: recipe.name,
      ingredients: recipe.ingredients,
      description: recipe.description,
    );
    await databaseHelper.insertRecipe(recipeModel);
  }

  @override
  Future<void> deleteRecipe(int id) async {
    await databaseHelper.deleteRecipe(id);
  }
}
