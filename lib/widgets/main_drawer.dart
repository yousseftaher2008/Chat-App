// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '/screens/settings_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});
  Widget buildListTile(BuildContext ctx, String title, IconData icon, String routeName) {
    return ListTile(
      leading: Icon(icon, size: 26),
      title: Text(title, style: Theme.of(ctx).textTheme.titleMedium,),
      onTap: () {
        Navigator.of(ctx).pushReplacementNamed(routeName);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            bottom: 20,
          ),
          height: 100,
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          color: Theme.of(context).accentColor,
          child: Text(
            "Cooking Up!",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        buildListTile(context, "Meals", Icons.restaurant, '/'),
        buildListTile(context, "Settings", Icons.settings, SettingsScreen.routeName),
      ],
    ));
  }
}
