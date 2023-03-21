import 'package:flutter/material.dart';
import '/screens/meal_detail_screen.dart';
import '../models/meal.dart';

class MealWidget extends StatelessWidget {
  const MealWidget(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.duration,
      required this.affordability,
      required this.complexity,
      super.key});

  final Affordability affordability;
  final Complexity complexity;
  final int duration;
  final String title, imageUrl, id;

  void selected(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      MealDetailScreen.routeName,
      arguments: id,
    );
  }

  String get complexityText {
    switch (complexity) {
      case Complexity.Simple:
        return "Simple";
      case Complexity.Challenging:
        return "Challenging";
      case Complexity.Hard:
        return "Hard";
      default:
        return "unknown";
    }
  }

  String get affordabilityText {
    switch (affordability) {
      case Affordability.Affordable:
        return "Affordable";
      case Affordability.Pricey:
        return "Pricey";
      case Affordability.Luxurious:
        return "Luxurious";
      default:
        return "unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selected(context),
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  const Icon(Icons.work),
                  Text(complexityText),
                ],
              ),
              SizedBox(
                height: 230,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(75.0),
                      child: Image.network(
                        imageUrl,
                        height: 150.0,
                        width: 150.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.schedule),
                        Text("$duration min"),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.attach_money),
                  Text(affordabilityText),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
