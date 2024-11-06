import 'package:flutter/material.dart';
import 'formScreen.dart'; // Importa la pantalla de formulario

class Detailscreen extends StatefulWidget {
  const Detailscreen({super.key});

  @override
  State<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  final List<String> ingredients = [
    'Matcha Powder',
    'Milk',
    'Ice',
    'Sugar',
    'Whipped Cream'
  ];

  final TextEditingController _descriptionController = TextEditingController(
    text:
        'El matcha es un tipo de té verde en polvo que se cultiva y procesa en Japón. A diferencia de las hojas de té verde que se infusionan en agua caliente y luego se eliminan, el polvo de matcha se mezcla con agua o leche, por lo que se consume en su totalidad.',
  );

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
                    ingredients.add(ingredientController.text);
                  } else {
                    int index = ingredients.indexOf(ingredient);
                    if (index != -1) {
                      ingredients[index] = ingredientController.text;
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
          ingredients: ingredients,
          description: _descriptionController.text,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        ingredients
          ..clear()
          ..addAll(result['ingredients']);
        _descriptionController.text = result['description'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            ...ingredients
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
                                color: Colors.green,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.add),
                                ),
                              ),
                            ),
                          ],
                        ),
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
              icon: Icon(Icons.edit),
              label: Text('Editar'),
            ),
            ElevatedButton.icon(
              onPressed: null,
              icon: Icon(Icons.delete),
              label: Text('Eliminar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientCard extends StatelessWidget {
  final String name;

  IngredientCard({required this.name});

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fastfood, size: 30, color: Colors.green),
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
    );
  }
}
