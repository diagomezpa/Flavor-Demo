import 'package:flavorbox/domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  RecipeModel({
    required int id,
    required String name,
    required List<String> ingredients,
    required String description,
  }) : super(
          id: id,
          name: name,
          ingredients: ingredients,
          description: description,
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients.join(','),
      'description': description,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: map['id'],
      name: map['name'],
      ingredients: map['ingredients'].split(','),
      description: map['description'],
    );
  }
}
