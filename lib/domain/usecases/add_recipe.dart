import 'package:flavorbox/domain/entities/recipe.dart';
import 'package:flavorbox/domain/repositories/recipe_repository.dart';

class AddRecipe {
  final RecipeRepository repository;

  AddRecipe(this.repository);

  Future<void> call(Recipe recipe) async {
    return await repository.addRecipe(recipe);
  }
}
