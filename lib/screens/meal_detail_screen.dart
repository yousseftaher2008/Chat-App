// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  const MealDetailScreen ({super.key});

  static const routeName = "/meal_detail";

  Widget textSection(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget homeSection(BuildContext context, Widget child) {
    return Container(
      height: 150,
      width: 300,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          color: Colors.white,
          borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(5),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String mealId = ModalRoute.of(context)?.settings.arguments as String;
    final selectedMeal = Dummy_Meal.firstWhere(
      (meal) => meal.id == mealId,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedMeal.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 300,
              child: Image.network(selectedMeal.imageUrl),
            ),
            // Text Container
            textSection(context, "ingredients"),
            // Ingredients Container
            homeSection(
              context,
              ListView.builder(
                itemBuilder: (ctx, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      color: Theme.of(context).accentColor,
                      child: Text(selectedMeal.ingredients[index]),
                    ),
                  );
                },
                itemCount: selectedMeal.ingredients.length,
              ),
            ),
            // Text Container
            textSection(context, "steps"),
            // Ingredients Container
            homeSection(
              context,
              ListView.builder(
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(child: Text("# ${(index + 1)}")),
                        title: Text(selectedMeal.steps[index]),
                      ),
                      const Divider()
                    ],
                  );
                },
                itemCount: selectedMeal.steps.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(child: const Icon(Icons.delete), onPressed: () {
        return Navigator.of(context).pop(mealId);
      },),
    );
  }
}
