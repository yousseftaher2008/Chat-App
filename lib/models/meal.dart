// ignore_for_file: constant_identifier_names
enum Complexity { Simple, Challenging, Hard }

enum Affordability { Affordable, Pricey, Luxurious }

class Meal {
  const Meal({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.categories,
    required this.ingredients,
    required this.steps,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegetarian,
    required this.isVegan,
    required this.duration,
    required this.complexity,
    required this.affordability,
  });

  final Affordability affordability;
  final Complexity complexity;
  final int duration;
  final String id, title, imageUrl;
  final bool isGlutenFree, isLactoseFree, isVegetarian, isVegan;
  final List<String> categories, ingredients, steps;
}
