import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static const routeName = "/settings";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var isGlutenFree = false;
  var isLactoseFree = false;
  var isVegetarian = false;
  var isVegan = false;

  Widget buildSwitchListTile(
      String title, bool isAble, void Function(bool) fun) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text("Only show the $title"),
      value: isAble,
      onChanged: fun,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Text(
              "Adjust your your meal selection",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                buildSwitchListTile(
                  "Gluten-free",
                  isGlutenFree,
                  (value) {
                    setState(
                      () {
                        isGlutenFree = value;
                      },
                    );
                  },
                ),
                buildSwitchListTile(
                  "Lactose-free",
                  isLactoseFree,
                  (value) {
                    setState(
                      () {
                        isLactoseFree = value;
                      },
                    );
                  },
                ),
                buildSwitchListTile(
                  "Vegetarian",
                  isVegetarian,
                  (value) {
                    setState(
                      () {
                        isVegetarian = value;
                      },
                    );
                  },
                ),
                buildSwitchListTile(
                  "Vegan",
                  isVegan,
                  (value) {
                    setState(
                      () {
                        isVegan = value;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
