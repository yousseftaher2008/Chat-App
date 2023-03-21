// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:third_app/dummy_data.dart';
import 'package:third_app/models/meal.dart';
import 'package:third_app/screens/settings_screen.dart';
import 'package:third_app/screens/tabs__screen.dart';

import '../screens/meal_detail_screen.dart';
import '../screens/category_meals_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map _settings = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };
  List<Meal> _availableMeals = Dummy_Meal;
  final List<Meal> _favoritesMeals = [];

  void _setFavorites(mealId) {
    int index = _favoritesMeals.indexWhere((meal) => meal.id == mealId);
    if (index == -1) {
      _favoritesMeals.add(Dummy_Meal.firstWhere((meal) => mealId == meal.id));
    } else {
      _favoritesMeals.removeWhere((meal) => mealId == meal.id);
    }
    setState(() {});
  }

  bool _isFavorite(mealId) {
    return _favoritesMeals.any((meal) => mealId == meal.id);
  }

  void _setSettings(Map newMap) {
    setState(() {
      _settings = newMap;

      _availableMeals = _availableMeals
          .where((meal) =>
              meal.isGlutenFree == _settings['gluten'] &&
              meal.isLactoseFree == _settings['lactose'] &&
              meal.isVegan == _settings['vegan'] &&
              meal.isVegetarian == _settings['vegetarian'])
          .toList();
    });
  }

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
      home: TabScreen(_favoritesMeals),
      routes: {
        CategoryMealsScreen.routeName: (context) =>
            CategoryMealsScreen(_availableMeals),
        MealDetailScreen.routeName: (context) =>
            MealDetailScreen(_isFavorite, _setFavorites),
        SettingsScreen.routeName: (context) =>
            SettingsScreen(_settings, _setSettings)
      },
      onUnknownRoute: (_) {
        return MaterialPageRoute(
            builder: (context) => TabScreen(_favoritesMeals));
      },
    );
  }
}
