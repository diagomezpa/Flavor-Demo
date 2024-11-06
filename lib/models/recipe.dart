class Recipe {
  final int? id;
  final String name;
  final List<String> ingredients;
  final String description;

  Recipe(
      {this.id,
      required this.name,
      required this.ingredients,
      required this.description});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients.join(','),
      'description': description,
    };
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      ingredients: map['ingredients'].split(','),
      description: map['description'],
    );
  }
}
