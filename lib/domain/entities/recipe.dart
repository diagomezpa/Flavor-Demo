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
}
