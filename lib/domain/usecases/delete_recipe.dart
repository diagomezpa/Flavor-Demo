import 'package:flavorbox/domain/repositories/recipe_repository.dart';

class DeleteRecipe {
  final RecipeRepository repository;

  DeleteRecipe(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteRecipe(id);
  }
}
