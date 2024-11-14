import 'package:flavorbox/data/repositories/recipe_repository_impl.dart';
import 'package:flavorbox/domain/entities/recipe.dart';
import 'package:flavorbox/domain/usecases/add_recipe.dart';
import 'package:flavorbox/domain/usecases/delete_recipe.dart';
import 'package:flavorbox/domain/usecases/get_recipes.dart';
import 'package:flavorbox/presentation/screens/detail_screen.dart';
import 'package:flavorbox/presentation/screens/form_screen.dart'; // Add this import
import 'package:flutter/material.dart';

import '../../data/services/json_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Recipe>> _recipes;
  List<Widget> cards = [];
  int cardCount = 0;
  late AddRecipe addRecipe;
  late DeleteRecipe deleteRecipe;

  @override
  void initState() {
    super.initState();
    // Inicializar con 15 tarjetas
    // for (int i = 1; i <= 15; i++) {
    //   cards.add(cardItem('Tarjeta $i', getColor(i)));
    // }
    final repository = RecipeRepositoryImpl(JsonService());
    final getRecipes = GetRecipes(repository);
    addRecipe = AddRecipe(repository);
    deleteRecipe = DeleteRecipe(repository);
    _recipes = getRecipes.call();
  }

  Color getColor(int index) {
    List<Color> colors = [
      Colors.teal,
    ];
    return colors[(index - 1) % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Recetas'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _recipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No hay recetas disponibles'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addNewRecipe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    child: Text(
                      'Agregar Nueva Receta',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ],
              ),
            );
          } else {
            List<Recipe> recipes = snapshot.data!;
            return Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      flex: 8,
                      child: ListView.builder(
                        padding: EdgeInsets.all(15.0),
                        itemCount: recipes.length,
                        itemBuilder: (context, index) {
                          return cardItem(recipes[index], getColor(index + 1));
                        },
                      ),
                    ),
                    Container(
                      height: 40.0, // Espacio para el botón
                    ),
                  ],
                ),
                Positioned(
                  bottom: 15,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _addNewRecipe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Nueva tarjeta',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<void> _addNewRecipe() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormScreen(
          ingredients: [],
          description: '',
          name: '',
        ),
      ),
    );

    if (result != null) {
      final newRecipe = Recipe(
        id: DateTime.now().millisecondsSinceEpoch,
        name: result['name'],
        ingredients: result['ingredients'],
        description: result['description'],
      );
      await addRecipe.call(newRecipe);
      setState(() {
        _recipes = GetRecipes(RecipeRepositoryImpl(JsonService())).call();
      });
    }
  }

  Future<void> _deleteRecipe(int id) async {
    await deleteRecipe.call(id);
    setState(() {
      _recipes = GetRecipes(RecipeRepositoryImpl(JsonService())).call();
    });
  }

  Widget cardItem(Recipe recipe, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Detailscreen(
              id: recipe.id!,
              name: recipe.name,
              ingredients: recipe.ingredients,
              description: recipe.description,
              onDelete: _deleteRecipe,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: double.infinity,
          height: 150.0, // Aumentar la altura de la tarjeta
          margin: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: color.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                recipe.name,
                style: TextStyle(fontSize: 24.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}