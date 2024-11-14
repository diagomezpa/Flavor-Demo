import 'package:flutter/material.dart';

class IngredientCard extends StatelessWidget {
  final String name;
  final VoidCallback? onDelete;

  IngredientCard({required this.name, this.onDelete});

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
          if (onDelete != null)
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
