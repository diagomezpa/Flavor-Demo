import 'package:flutter/material.dart';
import 'form_screen.dart'; // Importa la pantalla de formulario
import 'package:flavorbox/presentation/widgets/ingredient_card.dart';

class Detailscreen extends StatefulWidget {
  final String name;
  final List<String> ingredients;
  final String description;
  final int id;
  final Function(int) onDelete;

  Detailscreen({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.description,
    required this.onDelete,
  });

  @override
  State<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  late TextEditingController _descriptionController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.description);
    _nameController = TextEditingController(text: widget.name);
  }

  void _showIngredientDialog({String? ingredient}) {
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
                    widget.ingredients.add(ingredientController.text);
                  } else {
                    int index = widget.ingredients.indexOf(ingredient);
                    if (index != -1) {
                      widget.ingredients[index] = ingredientController.text;
                    }
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

  void _editDetails() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormScreen(
          name: _nameController.text,
          ingredients: widget.ingredients,
          description: _descriptionController.text,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        widget.ingredients
          ..clear()
          ..addAll(result['ingredients']);
        _descriptionController.text = result['description'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Receta'),
        backgroundColor: Colors.teal,
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
                            ...widget.ingredients
                                .map((ingredient) => GestureDetector(
                                      onTap: () {
                                        _showIngredientDialog(
                                            ingredient: ingredient);
                                      },
                                      child: IngredientCard(name: ingredient),
                                    ))
                                .toList(),
                            GestureDetector(
                              onTap: _showIngredientDialog,
                              child: Card(
                                color: Colors.teal,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.add, color: Colors.white),
                                ),
                              ),
                            ),
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
              onPressed: () {
                widget.onDelete(widget.id);
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
