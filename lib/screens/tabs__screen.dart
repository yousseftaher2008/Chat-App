// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';
import 'categories_screen.dart';
import 'favorites_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final List<Map<String, dynamic>> _screens = const [
    {
      "page": CategoriesScreen(),"title":"Categories",
    },
    {
      "page": FavoritesScreen(),"title":"Favorites",
    }
  ];
  int _screenIndex = 0;
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
