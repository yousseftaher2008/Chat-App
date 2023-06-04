import "package:chat_app/widgets/auth/image_input.dart";
import "package:chat_app/widgets/search/search.dart";
import "package:flutter/material.dart";
import "/screens/chats_screen.dart";
import "package:connectivity_plus/connectivity_plus.dart";

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({super.key});

  static const String routeName = "/new_group";

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final AppBar appBar = AppBar(
      title: const Text("New Group"),
    );
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
                            labelText: "Enter the user Id"),
                        controller: controller,
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    Search(
                      controller.text,
                      onlyFriends: true,
                    ),
                  ],
                ),
              ),
            ),
            /*
            todo:
             takes users functionality
             if users take more than one
             add a group image fun
             */
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.arrow_forward),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (ctx) {
                      return Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          right: 15,
                          left: 15,
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ImageInput(
                              (image) {},
                            ),
                            const Expanded(
                                child: TextField(
                              decoration:
                                  InputDecoration(labelText: "GroupName"),
                            )),
                          ],
                        ),
                      );
                    });
              },
            ),
          );
        });
  }
}
