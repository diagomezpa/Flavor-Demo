import 'package:flavorbox/domain/entities/recipe.dart';
import 'package:flavorbox/domain/repositories/recipe_repository.dart';

class GetRecipe {
  final RecipeRepository repository;

  GetRecipe(this.repository);

  Future<Recipe> call(int id) async {
    return await repository.getRecipe(id);
  }
}
