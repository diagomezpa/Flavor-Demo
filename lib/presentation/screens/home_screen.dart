import 'package:flavorbox/domain/entities/recipe.dart';
import 'package:flavorbox/domain/usecases/add_recipe.dart';
import 'package:flavorbox/domain/usecases/delete_recipe.dart';
import 'package:flavorbox/domain/usecases/get_recipes.dart';
import 'package:flavorbox/presentation/screens/detail_screen.dart';
import 'package:flavorbox/presentation/screens/form_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final GetRecipes getRecipes;
  final AddRecipe addRecipe;
  final DeleteRecipe deleteRecipe;

  HomeScreen({
    required this.getRecipes,
    required this.addRecipe,
    required this.deleteRecipe,
  });
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Recipe>> _recipes;

  @override
  void initState() {
    super.initState();
    _recipes = widget.getRecipes.call();
  }

  void _loadRecipes() {
    setState(() {
      _recipes = widget.getRecipes.call();
    });
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
                      height: 40.0,
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
    final result = await Navigator.pushNamed(
      context,
      '/form',
      arguments: {'id': null},
    );

    _loadRecipes();
  }

  Widget cardItem(Recipe recipe, Color color) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          '/detail',
          arguments: {'id': recipe.id},
        );

        _loadRecipes();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: double.infinity,
          height: 150.0,
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
