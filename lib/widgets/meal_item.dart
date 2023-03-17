import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealWidget extends StatelessWidget {
  const MealWidget(
      {required this.title,
      required this.imageUrl,
      required this.duration,
      required this.affordability,
      required this.complexity,
      super.key});

  final Affordability affordability;
  final Complexity complexity;
  final int duration;
  final String title, imageUrl;

  void selected() {}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: selected,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: const [
                  Icon(Icons.badge),
                  Text("Simple"),
                ],
              ),
              SizedBox(
                height: 230,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleLarge,),
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
                        const Icon(Icons.access_time),
                        Text(duration.toString()),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                    children: const [
                      Icon(Icons.attach_money),
                      Text("Affordable"),
                    ],
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
