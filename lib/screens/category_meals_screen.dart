// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:third_app/models/meal.dart';
import '../dummy_data.dart';
import '../widgets/meal_item.dart';

class CategoryMealsScreen extends StatefulWidget {
  const CategoryMealsScreen ({super.key});

  static const routeName = "/category-meals";

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  var args;
  List<Meal> categories = [];
  var title;
    @override
  void didChangeDependencies() {
    args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final id = args["id"];
    title = args["title"];
    categories = Dummy_Meal.where((meal) {
      return meal.categories.contains(id);
    }).toList();
    super.didChangeDependencies();
  }
    
  void _removeMeal(mealId)
  {
    setState((){
      categories.removeWhere((meal) => meal.id == mealId);
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
          final mealInfo = categories[index];
          return MealWidget(
            id: mealInfo.id,
            title: mealInfo.title,
            duration: mealInfo.duration,
            imageUrl: mealInfo.imageUrl,
            affordability: mealInfo.affordability,
            complexity: mealInfo.complexity,
            removeMeal: _removeMeal,
          );
        },
        itemCount: categories.length,
      ),
    );
  }
}
