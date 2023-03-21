import 'package:flutter/material.dart';
import 'package:third_app/models/meal.dart';

import '../widgets/meal_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen(this.favoritesMeals, {super.key});
  final List<Meal> favoritesMeals;
  @override
  Widget build(BuildContext context) {
    if (favoritesMeals.isEmpty) {
      return const Center(
        child: Text("You have no favorites yet"),
      );
    } else {
      return ListView.builder(
        itemBuilder: (context, index) {
          final mealInfo = favoritesMeals[index];
          return MealWidget(
            id: mealInfo.id,
            title: mealInfo.title,
            duration: mealInfo.duration,
            imageUrl: mealInfo.imageUrl,
            affordability: mealInfo.affordability,
            complexity: mealInfo.complexity,
          );
        },
        itemCount: favoritesMeals.length,
      );
    }
  }
}
