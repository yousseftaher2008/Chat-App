import 'package:flutter/material.dart';
import 'package:third_app/widgets/main_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen(this._settings, this.change, {super.key});
  final Function change;
  final Map _settings;
  static const routeName = "/settings";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        actions: [
          IconButton(
            onPressed: () {
              widget.change({
                'gluten': widget._settings["gluten"],
                'lactose': widget._settings["lactose"],
                'vegan': widget._settings["vegan"],
                'vegetarian': widget._settings["vegetarian"],
              });
            },
            icon: const Icon(Icons.save_alt_outlined),
          )
        ],
      ),
      drawer: const MainDrawer(),
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
                  widget._settings["gluten"]!,
                  (value) {
                    setState(
                      () {
                        widget._settings["gluten"] = value;
                      },
                    );
                  },
                ),
                buildSwitchListTile(
                  "Lactose-free",
                  widget._settings["lactose"]!,
                  (value) {
                    setState(
                      () {
                        widget._settings["lactose"] = value;
                      },
                    );
                  },
                ),
                buildSwitchListTile(
                  "Vegetarian",
                  widget._settings["vegetarian"]!,
                  (value) {
                    setState(
                      () {
                        widget._settings["vegetarian"] = value;
                      },
                    );
                  },
                ),
                buildSwitchListTile(
                  "Vegan",
                  widget._settings["vegan"]!,
                  (value) {
                    setState(
                      () {
                        widget._settings["vegan"] = value;
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
