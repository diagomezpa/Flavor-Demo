import 'package:flavorbox/data/repositories/recipe_repository_impl.dart';
import 'package:flavorbox/data/services/json_service.dart';
import 'package:flavorbox/domain/entities/recipe.dart';
import 'package:flavorbox/domain/usecases/add_recipe.dart';
import 'package:flavorbox/domain/usecases/delete_recipe.dart';
import 'package:flavorbox/domain/usecases/edit_recipe.dart';
import 'package:flavorbox/presentation/widgets/ingredient_card.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  final List<String> ingredients;
  final String description;
  final String name;
  final int? id;
  late TextEditingController _nameController;
  FormScreen({
    required this.ingredients,
    required this.description,
    required this.name,
    this.id,
  });

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late AddRecipe addRecipe;
  late EditRecipe editRecipe;
  final _formKey = GlobalKey<FormState>();
  late List<String> _ingredients;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String? _ingredientError;
  @override
  void initState() {
    super.initState();
    _ingredients = List.from(widget.ingredients);
    _nameController = TextEditingController();
    _descriptionController = TextEditingController(text: widget.description);
    _nameController = TextEditingController(text: widget.name);
    final repository = RecipeRepositoryImpl(JsonService());
    addRecipe = AddRecipe(repository);
    editRecipe = EditRecipe(repository);
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
        id: widget.id == null
            ? DateTime.now().millisecondsSinceEpoch
            : widget.id,
        name: _nameController.text,
        ingredients: _ingredients,
        description: _descriptionController.text,
      );
      if (widget.id == null) {
        await addRecipe.call(newRecipe);
      } else {
        await editRecipe.call(newRecipe);
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
