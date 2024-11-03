import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> cards = [];
  int cardCount = 0;

  @override
  void initState() {
    super.initState();
    // Inicializar con 15 tarjetas
    for (int i = 1; i <= 15; i++) {
      cards.add(cardItem('Tarjeta $i', getColor(i)));
    }
  }

  Color getColor(int index) {
    List<Color> colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.pink,
      Colors.teal,
      Colors.lime,
      Colors.indigo,
      Colors.brown,
      Colors.grey,
      Colors.amber,
      Colors.deepOrange,
    ];
    return colors[(index - 1) % colors.length];
  }

  void addCard() {
    setState(() {
      cardCount++;
      cards.add(
          cardItem('Tarjeta ${cards.length + 1}', getColor(cards.length + 1)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de Tarjetas'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 8,
                child: ListView(
                  padding: EdgeInsets.all(15.0),
                  children: cards,
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
                onPressed: addCard,
                child: const Text(
                  'Nueva tarjeta',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardItem(String title, Color color) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: double.infinity,
        height: 150.0, // Aumentar la altura de la tarjeta
        margin: EdgeInsets.symmetric(vertical: 0.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 24.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
