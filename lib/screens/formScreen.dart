import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  final List<String> ingredients;
  final String description;
  late TextEditingController _nameController;
  FormScreen({required this.ingredients, required this.description});

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  late List<String> _ingredients;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _ingredients = List.from(widget.ingredients);
    _nameController = TextEditingController();
    _descriptionController = TextEditingController(text: widget.description);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nombre',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Ingrese el nombre de la receta',
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Descripción',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Ingrese la descripción',
                ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop({
            'name': _nameController.text,
            'ingredients': _ingredients,
            'description': _descriptionController.text,
          });
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.save, color: Colors.black),
      ),
    );
  }
}

class IngredientCard extends StatelessWidget {
  final String name;
  final VoidCallback onDelete;

  IngredientCard({required this.name, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: onDelete,
              child: Icon(Icons.close, size: 20, color: Colors.teal),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fastfood, size: 30, color: Colors.teal),
                SizedBox(height: 5),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
