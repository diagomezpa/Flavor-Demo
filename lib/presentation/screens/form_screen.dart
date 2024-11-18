import 'package:flavorbox/data/repositories/recipe_repository_impl.dart';
import 'package:flavorbox/data/services/json_service.dart';
import 'package:flavorbox/domain/entities/recipe.dart';
import 'package:flavorbox/domain/usecases/add_recipe.dart';
import 'package:flavorbox/domain/usecases/delete_recipe.dart';
import 'package:flavorbox/domain/usecases/edit_recipe.dart';
import 'package:flavorbox/domain/usecases/get_recipe.dart';
import 'package:flavorbox/presentation/widgets/ingredient_card.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  final AddRecipe addRecipe;
  final EditRecipe editRecipe;
  final GetRecipe getRecipe;

  FormScreen({
    required this.getRecipe,
    required this.addRecipe,
    required this.editRecipe,
  });

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late List<String> _ingredients;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late Recipe recipe;
  String? _ingredientError;
  late int? id;
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

  void _showIngredientDialog({String? ingredient, int? index}) {
    final _ingredientFormKey = GlobalKey<FormState>();
    final _ingredientDialogController = TextEditingController(text: ingredient);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ingredient == null
              ? 'Agregar Ingrediente'
              : 'Editar Ingrediente'),
          content: Form(
            key: _ingredientFormKey,
            child: TextFormField(
              controller: _ingredientDialogController,
              decoration: InputDecoration(hintText: 'Ingrese el ingrediente'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El ingrediente no puede estar vacío';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (_ingredientFormKey.currentState!.validate()) {
                  setState(() {
                    if (ingredient == null) {
                      _ingredients.add(_ingredientDialogController.text);
                    } else if (index != null) {
                      _ingredients[index] = _ingredientDialogController.text;
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text(ingredient == null ? 'Agregar' : 'Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    setState(() {
      _ingredientError =
          _ingredients.isEmpty ? 'Tiene que tener ingredientes' : null;
    });

    if (_formKey.currentState!.validate() && _ingredientError == null) {
      final newRecipe = Recipe(
        id: id == null ? DateTime.now().millisecondsSinceEpoch : id,
        name: _nameController.text,
        ingredients: _ingredients,
        description: _descriptionController.text,
      );
      if (id == null) {
        await widget.addRecipe.call(newRecipe);
      } else {
        await widget.editRecipe.call(newRecipe);
      }

      Navigator.pop(context, {
        'name': _nameController.text,
        'ingredients': _ingredients,
        'description': _descriptionController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Detalles'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nombre',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Ingrese el nombre de la receta',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No puede estar vacío';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                Text(
                  'Descripción',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Ingrese la descripción',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No puede estar vacío';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Ingredientes',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ..._ingredients.asMap().entries.map((entry) {
                        int index = entry.key;
                        String ingredient = entry.value;
                        return GestureDetector(
                          onTap: () {
                            _showIngredientDialog(
                                ingredient: ingredient, index: index);
                          },
                          child: IngredientCard(
                            name: ingredient,
                            onDelete: () => _removeIngredient(index),
                          ),
                        );
                      }).toList(),
                      GestureDetector(
                        onTap: () {
                          _showIngredientDialog();
                        },
                        child: Card(
                          color: Colors.teal,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 16), // Espacio vertical
                    ],
                  ),
                ),
                SizedBox(height: 16), // Espacio vertical
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _submitForm();
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.save, color: Colors.black),
      ),
    );
  }
}
