import 'package:flavorbox/data/repositories/recipe_repository_impl.dart';
import 'package:flavorbox/data/services/json_service.dart';
import 'package:flavorbox/domain/usecases/add_recipe.dart';
import 'package:flavorbox/domain/usecases/delete_recipe.dart';
import 'package:flavorbox/domain/usecases/get_recipes.dart';
import 'package:flavorbox/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  final repository = RecipeRepositoryImpl(JsonService());
  final getRecipes = GetRecipes(repository);
  final addRecipe = AddRecipe(repository);
  final deleteRecipe = DeleteRecipe(repository);

  runApp(MyApp(
    getRecipes: getRecipes,
    addRecipe: addRecipe,
    deleteRecipe: deleteRecipe,
  ));
}

class MyApp extends StatelessWidget {
  final GetRecipes getRecipes;
  final AddRecipe addRecipe;
  final DeleteRecipe deleteRecipe;

  MyApp({
    required this.getRecipes,
    required this.addRecipe,
    required this.deleteRecipe,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flavor Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16.0),
        ),
      ),
      home: HomeScreen(
        getRecipes: getRecipes,
        addRecipe: addRecipe,
        deleteRecipe: deleteRecipe,
      ),
    );
  }
}
