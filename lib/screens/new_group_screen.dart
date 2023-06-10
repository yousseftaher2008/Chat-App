import "dart:io";

import "package:chat_app/providers/users_providers.dart";
import "package:chat_app/widgets/auth/image_input.dart";
import "package:chat_app/widgets/search/search.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:searchbar_animation/searchbar_animation.dart";
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
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  File? storedImage;
  String? groupName;
  final AppBar appBar = AppBar(
    title: const Text("New Group"),
  );

  @override
  void dispose() {
    _form.currentState != null ? _form.currentState!.dispose() : null;
    super.dispose();
  }

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
            key: _scaffold,
            appBar: appBar,
            body: SingleChildScrollView(
              child: SizedBox(
                height: height,
                child: Column(
                  children: [
                    SearchBarAnimation(
                      textEditingController: controller,
                      cursorColour: Colors.blue,
                      isOriginalAnimation: true,
                      buttonBorderColour: Colors.black45,
                      secondaryButtonWidget:
                          const Icon(Icons.arrow_back_ios_rounded),
                      buttonWidget: const Icon(Icons.search),
                      trailingWidget: GestureDetector(
                          child: const Icon(Icons.clear),
                          onTap: controller.text != ''
                              ? () {
                                  FocusScope.of(context).unfocus();
                                  controller.text = '';
                                }
                              : null),
                      hintText: "User Id",
                      onChanged: (_) => setState(() {}),
                    ),
                    Search(
                      controller.text,
                      onlyFriends: true,
                    ),
                  ],
                ),
              ),
            ),
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
                                          assetImage: "group.jpg",
                                        ),
                                        Expanded(
                                            child: Form(
                                          key: _form,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                                labelText: "GroupName"),
                                            validator: (value) => value ==
                                                        null ||
                                                    value == ""
                                                ? "Please enter the group name"
                                                : value.length < 4
                                                    ? "The group name should be more than 4 characters"
                                                    : null,
                                            onChanged: (value) {
                                              setState(() {
                                                groupName = value;
                                              });
                                            },
                                          ),
                                        )),
                                      ],
                                    ),
                                    if (!loading)
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (_form.currentState == null ||
                                              !_form.currentState!.validate() ||
                                              loading) {
                                            return;
                                          }
                                          _form.currentState!.save();
                                          setState(() {
                                            loading = true;
                                          });
                                          if (groupName != null) {
                                            final String currentUser =
                                                usersProvider.userId;
                                            late final url;
                                            late final ref;
                                            final String chatId =
                                                usersProvider.generateChatId();
                                            if (storedImage == null) {
                                              ref = FirebaseStorage.instance
                                                  .ref()
                                                  .child("users_images")
                                                  .child("group.jpg");
                                              url = await ref.getDownloadURL();
                                            } else {
                                              url =
                                                  await usersProvider.sendFile(
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
                                            Navigator.of(_scaffold
                                                            .currentContext !=
                                                        null
                                                    ? _scaffold.currentContext!
                                                    : context)
                                                .popUntil(
                                                    (route) => route.isFirst);
                                            await Navigator.of(_scaffold
                                                            .currentContext !=
                                                        null
                                                    ? _scaffold.currentContext!
                                                    : context)
                                                .pushReplacementNamed(
                                              ChatsScreen.routeName,
                                            );
                                          }
                                        },
                                        child: const Text("Create Group"),
                                      ),
                                    if (loading)
                                      const Center(
                                        child: CircularProgressIndicator(),
                                      ),
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
