import 'package:flavorbox/presentation/widgets/ingredient_card.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  final List<String> ingredients;
  final String description;
  final String name;
  late TextEditingController _nameController;
  FormScreen(
      {required this.ingredients,
      required this.description,
      required this.name});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
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
  }

  void _showIngredientDialog({String? ingredient, int? index}) {
    final TextEditingController ingredientController = TextEditingController(
      text: ingredient ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ingredient == null
              ? 'Agregar Ingrediente'
              : 'Editar Ingrediente'),
          content: TextField(
            controller: ingredientController,
            decoration: InputDecoration(hintText: 'Ingrese el ingrediente'),
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
                setState(() {
                  if (ingredient == null) {
                    _ingredients.add(ingredientController.text);
                  } else if (index != null) {
                    _ingredients[index] = ingredientController.text;
                  }
                });
                Navigator.of(context).pop();
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

  void _submitForm() {
    setState(() {
      _ingredientError =
          _ingredients.isEmpty ? 'Ingredients cannot be empty' : null;
    });

    if (_formKey.currentState!.validate() && _ingredientError == null) {
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
