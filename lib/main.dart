// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:third_app/screens/settings_screen.dart';
import 'package:third_app/screens/tabs__screen.dart';

import '../screens/meal_detail_screen.dart';
import '../screens/category_meals_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMails',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.amber,
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        fontFamily: "Raleway",
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyLarge: const TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
              titleLarge: const TextStyle(
                fontFamily: "RobotoCondensed",
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: const TextStyle(
                fontFamily: "RobotoCondensed",
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      home: const TabScreen(),
      routes: {
        CategoryMealsScreen.routeName: (context) => const CategoryMealsScreen(),
        MealDetailScreen.routeName: (context) => const MealDetailScreen(),
        SettingsScreen.routeName: (context) => const SettingsScreen()
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const TabScreen());
      },
    );
  }
}
