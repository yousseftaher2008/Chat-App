// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:third_app/models/meal.dart';
import '../widgets/meal_item.dart';

class CategoryMealsScreen extends StatefulWidget {
  const CategoryMealsScreen(this.categories, {super.key});
  final List<Meal> categories;
  static const routeName = "/category-meals";

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  List categoriesState = [];
  var args;
  var title;
  var id;
  @override
  void didChangeDependencies() {
    categoriesState = widget.categories;
    args = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    id = args["id"];
    title = args["title"];
    categoriesState = widget.categories.where((meal) {
      return meal.categories.contains(id);
    }).toList();

    super.didChangeDependencies();
  }

  void _removeMeal(mealId) {
    setState(() {
      categoriesState.removeWhere((meal) => meal.id == mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title.toString()),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final mealInfo = categoriesState[index];
          return MealWidget(
            id: mealInfo.id,
            title: mealInfo.title,
            duration: mealInfo.duration,
            imageUrl: mealInfo.imageUrl,
            affordability: mealInfo.affordability,
            complexity: mealInfo.complexity,
          );
        },
        itemCount: categoriesState.length,
      ),
    );
  }
}
