import 'package:flavorbox/domain/entities/recipe.dart';
import 'package:flavorbox/domain/repositories/recipe_repository.dart';

class GetRecipes {
  final RecipeRepository repository;

  GetRecipes(this.repository);

  Future<List<Recipe>> call() async {
    return await repository.getRecipes();
  }
}
