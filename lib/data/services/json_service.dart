import 'dart:convert';
import 'dart:io';
import 'package:flavorbox/data/models/recipe_model.dart';

class JsonService {
  // Cambia la función para obtener la ruta del archivo usando el directorio temporal.
  Future<String> _getFilePath() async {
    final directory = Directory.systemTemp;
    return '${directory.path}/recipes.json';
  }

  Future<File> _getFile() async {
    final path = await _getFilePath();
    final file = File(path);
    if (!(await file.exists())) {
      await file.create(recursive: true); // Crea el archivo si no existe
      await file
          .writeAsString('[]'); // Inicializa el archivo con un array vacío
    }
    return file;
  }

  Future<List<RecipeModel>> fetchRecipes() async {
    try {
      final file = await _getFile();
      final contents = await file.readAsString();
      final List<dynamic> jsonData = json.decode(contents);
      return jsonData.map((json) => RecipeModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception('Error reading recipes: $e');
    }
  }

  Future<void> saveRecipes(List<RecipeModel> recipes) async {
    final file = await _getFile();
    final jsonData = recipes.map((recipe) => recipe.toMap()).toList();
    await file.writeAsString(json.encode(jsonData));
  }

  Future<void> insertRecipe(RecipeModel recipe) async {
    final recipes = await fetchRecipes();
    recipes.add(recipe);
    await saveRecipes(recipes);
  }

  Future<void> deleteRecipe(int id) async {
    final recipes = await fetchRecipes();
    final updatedRecipes = recipes.where((recipe) => recipe.id != id).toList();
    await saveRecipes(updatedRecipes);
  }
}
