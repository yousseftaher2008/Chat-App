import "package:chat_app/widgets/search/search.dart";
import "package:flutter/material.dart";
import "/screens/chats_screen.dart";
import "package:connectivity_plus/connectivity_plus.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String routeName = "/search";

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final controller = TextEditingController();
  final AppBar appBar = AppBar(
    title: const Text("Search..."),
  );
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height;
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, connection) {
          if (connection.data == ConnectivityResult.none) {
            Navigator.of(context).pushReplacementNamed(ChatsScreen.routeName);
          }
          return Scaffold(
            appBar: appBar,
            body: SingleChildScrollView(
              child: SizedBox(
                height: height,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      child: TextField(
                        decoration: const InputDecoration(
                            labelText: "Enter the user ID"),
                        controller: controller,
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                    if (controller.text != "") Search(controller.text),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
