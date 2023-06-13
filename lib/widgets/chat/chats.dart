import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "chat_item.dart";
import "../../providers/users_providers.dart";
import "../../screens/chat_screen.dart";

// ignore: must_be_immutable
class Chats extends StatefulWidget {
  const Chats({super.key});
  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with WidgetsBindingObserver {
  bool isInit = false;
  late UsersProvider usersProvider;
  @override
  void didChangeDependencies() {
    if (!isInit) {
      usersProvider = Provider.of<UsersProvider>(context, listen: false);
      usersProvider.setStatus("online");
      WidgetsBinding.instance.addObserver(this);
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      usersProvider.setStatus("online");
    } else {
      usersProvider.setStatus("offline");
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    int printed = 0;
    Widget chat_item(
      bool isGroup,
      String chatName,
      String chatImage,
      String lastMessage,
      String chatId,
      String type, [
      String? userStatus,
      String? userId2,
    ]) {
      printed++;
      return GestureDetector(
        onLongPress: !isGroup
            ? () async {
                await showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("Do you want to block $chatName"),
                    actions: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "NO",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await usersProvider.blockUser(userId2!);
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "Yes",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
            : () {},
        onTap: () {
          Navigator.of(context).pushNamed(
            ChatScreen.routeName,
            arguments: {
              "type": type,
              "chatName": chatName,
              if (!isGroup) "status": userStatus!,
              if (!isGroup) "userId": userId2!,
              "chatId": chatId,
            },
          );
        },
        child: ChatItem(
          chatName,
          chatImage,
          true,
          isGroup ? "group.jpg" : "user.png",
          lastMessage: lastMessage,
          key: Key(chatId),
        ),
      );
    }

    return StreamBuilder(
        stream: usersProvider.users,
        builder: (_, usersSnapshot) {
          if (usersSnapshot.hasData) {
            final users = usersSnapshot.data!.docs;
            return StreamBuilder(
              stream: usersProvider.stChats,
              builder: (_, chatsSnapshot) {
                if (chatsSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (chatsSnapshot.data != null) {
                  final doc = chatsSnapshot.data!.docs;
                  return ListView.builder(
                      itemCount: doc.length,
                      itemBuilder: (ctx, i) {
                        final String userId = usersProvider.userId;
                        late String chatName;
                        late String chatImage;
                        late String userStatus;
                        late String userId2;
                        final bool isGroup = doc[i]["type"] == "group";
                        bool isIn = false;

                        late String lastMessage;
                        if (doc[i]["lastMessage"].length > 50) {
                          lastMessage =
                              "${doc[i]["lastMessage"].substring(0, 46)}...";
                        } else {
                          lastMessage = doc[i]["lastMessage"];
                        }

                        if (doc[i]["type"] == "group") {
                          chatName = doc[i]["groupName"];
                          chatImage = doc[i]["groupImage"];
                          final members = doc[i]["members"];
                          for (var h = 0; h < doc[i]["members"].length; h++) {
                            if (members[h] == userId) {
                              isIn = true;
                            }
                          }
                          if (isIn) {
                            return Column(
                              children: [
                                if (printed != 0)
                                  const Divider(
                                    color: Colors.black54,
                                  ),
                                chat_item(
                                  isGroup,
                                  chatName,
                                  chatImage,
                                  lastMessage,
                                  doc[i].id,
                                  doc[i]["type"],
                                ),
                              ],
                            );
                          }
                          return Container();
                        } else {
                          if (doc[i]["userId1"] == userId.trim()) {
                            for (var j = 0; j < users.length; j++) {
                              userId2 = doc[i]["userId2"].toString().trim();
                              if (users[j].id == userId2) {
                                chatName = users[j]["username"];
                                chatImage = users[j]["image_url"];
                                userStatus = users[j]["status"];
                              }
                            }
                          } else if (doc[i]["userId2"] == userId) {
                            userId2 = doc[i]["userId1"].toString().trim();
                            for (var j = 0; j < users.length; j++) {
                              if (users[j].id == userId2) {
                                chatName = users[j]["username"];
                                chatImage = users[j]["image_url"];
                                userStatus = users[j]["status"];
                              }
                            }
                          } else {
                            return Container();
                          }
                        }

                        return Column(
                          children: [
                            if (printed != 0)
                              const Divider(
                                color: Colors.black54,
                              ),
                            chat_item(
                              isGroup,
                              chatName,
                              chatImage,
                              lastMessage,
                              doc[i].id,
                              doc[i]["type"],
                              userStatus,
                              userId2,
                            ),
                          ],
                        );
                      });
                }
                return Container();
              },
            );
          }
          return Container();
        });
  }
}
