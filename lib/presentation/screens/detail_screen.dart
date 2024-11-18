import 'package:flavorbox/data/repositories/recipe_repository_impl.dart';
import 'package:flavorbox/data/services/json_service.dart';
import 'package:flavorbox/domain/entities/recipe.dart';
import 'package:flavorbox/domain/usecases/delete_recipe.dart';
import 'package:flavorbox/domain/usecases/get_recipe.dart';
import 'package:flutter/material.dart';
import 'form_screen.dart'; // Importa la pantalla de formulario
import 'package:flavorbox/presentation/widgets/ingredient_card.dart';

class Detailscreen extends StatefulWidget {
  final GetRecipe getRecipe;
  final DeleteRecipe deleteRecipe;

  Detailscreen({
    required this.deleteRecipe,
    required this.getRecipe,
  });

  @override
  State<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  late int id;
  late Recipe recipe;
  late List<String> _ingredients;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _ingredients = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    super.didChangeDependencies();
    if (!_isInitialized) {
      _initializeForm();
      _isInitialized = true;
    }
  }

  void _initializeForm() {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    id = args['id'] ?? null;
    if (id != null) {
      widget.getRecipe.call(args['id']).then((recipe) {
        setState(() {
          this.recipe = recipe;
          _ingredients = List.from(recipe.ingredients);
          _descriptionController.text = recipe.description;
          _nameController.text = recipe.name;
        });
      });
    } else {
      _ingredients = [];
    }
  }

  Future<void> _handleDelete() async {
    // Llama al caso de uso de eliminación
    await widget.deleteRecipe.call(id);
  }

  void _editDetails() async {
    final result = await Navigator.of(context).pushNamed(
      '/form',
      arguments: {
        'id': id,
      },
    );
    if (result != null) {
      widget.getRecipe.call(id).then((recipe) {
        setState(() {
          this.recipe = recipe;
          _descriptionController.text = recipe.description;
          _nameController.text = recipe.name;
          _ingredients = List.from(recipe.ingredients);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Receta'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context,
                true); // Devuelve true cuando se presiona la flecha de regreso
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                  child: Image.network(
                    'https://www.semana.com/resizer/v2/GBBYJH5YMZC6PEINHE3HZZH4TY.jpg?auth=f21d7fbf15c15316b80dd213fb2c635e4445db8e08133172d69a4956d7f417db&smart=true&quality=75&width=1280&height=720&fitfill=false',
                    width: double.infinity,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Nombre de la Receta',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _nameController.text,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Descripción',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _descriptionController.text,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Ingredientes',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ..._ingredients
                                .map((ingredient) =>
                                    IngredientCard(name: ingredient))
                                .toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _editDetails,
              icon: Icon(Icons.edit, color: Colors.black),
              label: Text(
                'Editar',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
            SizedBox(height: 16), // Espacio vertical
            ElevatedButton.icon(
              onPressed: () async {
                await _handleDelete();
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete, color: Colors.black),
              label: Text(
                'Eliminar',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
