import 'package:flavorbox/domain/entities/recipe.dart';
import 'package:flavorbox/domain/repositories/recipe_repository.dart';

class EditRecipe {
  final RecipeRepository repository;

  EditRecipe(this.repository);

  Future<void> call(Recipe recipe) async {
    await repository.editRecipe(recipe);
  }
}
