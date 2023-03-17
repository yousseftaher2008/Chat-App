import 'package:flutter/material.dart';
import '../dummy_data.dart';
import '../widgets/meal_item.dart';

class CategoryMeals extends StatelessWidget {
  const CategoryMeals({super.key});

  static const routeName = "/category-meals";

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final id = args["id"];
    final title = args["title"];
    final categories = Dummy_Meal.where((meal) {
      return meal.categories.contains(id);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(title.toString()),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final mealInfo = categories[index];
          return MealWidget(
            title: mealInfo.title,
            duration: mealInfo.duration,
            imageUrl: mealInfo.imageUrl,
            affordability: mealInfo.affordability,
            complexity: mealInfo.complexity,
          );
        },
        itemCount: categories.length,
      ),
    );
  }
}
