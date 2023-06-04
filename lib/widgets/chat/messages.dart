import "package:connectivity_plus/connectivity_plus.dart";

import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../providers/users_providers.dart";
import "../../screens/chats_screen.dart";
import "message_item.dart";

class Messages extends StatelessWidget {
  const Messages(this.chatId, {super.key});
  final chatId;

  @override
  Widget build(BuildContext context) {
    final UsersProvider usersProvider = Provider.of<UsersProvider>(context);
    return StreamBuilder<ConnectivityResult>(
        stream: Connectivity().onConnectivityChanged,
        builder: (context, connection) {
          if (connection.data == ConnectivityResult.none) {
            Navigator.of(context).pushReplacementNamed(ChatsScreen.routeName);
          }
          return StreamBuilder(
              stream: usersProvider.chatMessages(chatId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data != null) {
                  final doc = snapshot.data!.docs;
                  //get the user
                  return ListView.builder(
                    reverse: true,
                    itemCount: doc.length,
                    //get is group
                    itemBuilder: (ctx, i) => FutureBuilder(
                        future: usersProvider.isGroup(chatId),
                        builder: (context, isGroup) {
                          if (isGroup.hasData &&
                              isGroup.connectionState !=
                                  ConnectionState.waiting) {
                            Future<void> deleteMessage() async {
                              await usersProvider.deleteMessage(
                                  doc[i].id, chatId);
                            }

                            return StreamBuilder(
                                stream: usersProvider.user(doc[i]["userId"]),
                                builder: (context, user) {
                                  if (user.hasData &&
                                      user.connectionState !=
                                          ConnectionState.waiting) {
                                    return MessageItem(
                                      doc[i]["${doc[i]["type"]}"],
                                      doc[i]["userId"],
                                      user.data!["username"],
                                      doc[i]["type"] == "photo",
                                      isGroup.data!,
                                      i == (doc.length - 1)
                                          ? false
                                          : doc[i + 1]["userId"] ==
                                              doc[i]["userId"],
                                      i == 0
                                          ? false
                                          : doc[(i - 1)]["userId"] ==
                                              doc[i]["userId"],
                                      deleteMessage,
                                      key: ValueKey(doc[i]),
                                    );
                                  }
                                  return Container();
                                });
                          }
                          return Container();
                        }),
                  );
                }
                return Container();
              });
        });
  }
}
