import "dart:io";

import "package:chat_app/providers/users_providers.dart";
import "package:chat_app/widgets/auth/image_input.dart";
import "package:chat_app/widgets/search/search.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "/screens/chats_screen.dart";
import "package:connectivity_plus/connectivity_plus.dart";

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({super.key});

  static const String routeName = "/new_group";

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  final controller = TextEditingController();
  File? storedImage;
  String? groupName;
  final AppBar appBar = AppBar(
    title: const Text("New Group"),
  );
  @override
  Widget build(BuildContext context) {
    final UsersProvider usersProvider = Provider.of<UsersProvider>(context);
    final double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height;
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (_, connection) {
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
                        onChanged: (value) => setState(() {}),
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
            floatingActionButton: usersProvider.tokenUsers.isNotEmpty
                ? FloatingActionButton(
                    child: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (ctx) {
                            bool loading = false;
                            return Container(
                              margin: EdgeInsets.only(
                                top: 15,
                                right: 15,
                                left: 15,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        ImageInput(
                                          (image) {
                                            setState(() {
                                              storedImage = image;
                                            });
                                          },
                                        ),
                                        Expanded(
                                            child: TextField(
                                          decoration: const InputDecoration(
                                              labelText: "GroupName"),
                                          onChanged: (value) {
                                            setState(() {
                                              groupName = value;
                                            });
                                          },
                                        )),
                                      ],
                                    ),
                                    if (loading)
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    if (!loading)
                                      ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              loading = true;
                                            });
                                            if (groupName != null) {
                                              final String currentUser =
                                                  usersProvider.userId;
                                              late final url;
                                              late final ref;
                                              final String chatId =
                                                  usersProvider
                                                      .generateChatId();
                                              if (storedImage == null) {
                                                ref = FirebaseStorage.instance
                                                    .ref()
                                                    .child("users_images")
                                                    .child("user.png");
                                                url =
                                                    await ref.getDownloadURL();
                                              } else {
                                                url = await usersProvider
                                                    .sendFile(
                                                        storedImage!, chatId);
                                                ref = FirebaseStorage.instance
                                                    .ref()
                                                    .child("users_images")
                                                    .child(chatId);
                                              }

                                              await usersProvider
                                                  .createGroup(chatId, {
                                                "groupName": groupName,
                                                "groupImage": url,
                                                "creator": currentUser,
                                                "type": "group",
                                                "members": [
                                                  currentUser,
                                                  ...usersProvider.tokenUsers,
                                                ],
                                                "admins": [
                                                  currentUser,
                                                ],
                                                "lastMessage": "",
                                                "lastMessageAt": "",
                                              });
                                              setState(() {
                                                loading = false;
                                              });
                                              Navigator.of(context).popUntil(
                                                  (route) => route.isFirst);
                                              await Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      ChatsScreen.routeName);
                                            }
                                          },
                                          child: const Text("Create Group"))
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  )
                : Container(),
          );
        });
  }
}
