// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:third_app/models/meal.dart';

import '../widgets/main_drawer.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen(this.favoritesMeals, {super.key});
  final List<Meal> favoritesMeals;
  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, dynamic>> _screens = [];
  int _screenIndex = 0;

  @override
  void initState() {
    _screens = [
      {
        "page": const CategoriesScreen(),
        "title": "Categories",
      },
      {
        "page": FavoritesScreen(widget.favoritesMeals),
        "title": "Favorites",
      }
    ];
    super.initState();
  }

  void _selectedScreen(int index) {
    setState(() {
      _screenIndex = index;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_screenIndex]["title"]),
      ),
      drawer: const MainDrawer(),
      body: _screens[_screenIndex]["page"],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedScreen,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _screenIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(Icons.star),
            label: "Favorites",
          ),
        ],
      ),
    );
  }
}
