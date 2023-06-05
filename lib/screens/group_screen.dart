import 'package:chat_app/providers/users_providers.dart';
import 'package:chat_app/widgets/group/group_arrangement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/chat/chat_item.dart';
import 'chats_screen.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});
  static const String routeName = "group_screen";

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  Widget build(BuildContext context) {
    final UsersProvider usersProvider = Provider.of<UsersProvider>(context);
    final String groupId = ModalRoute.of(context)!.settings.arguments as String;
    Future<void> _showDialog(BuildContext context, List members) async {
      List<Widget> widgets = [];
      await showDialog(
        context: context,
        builder: (ctx) => FutureBuilder(
            future: usersProvider.fuUsers,
            builder: (context, usersData) {
              if (usersData.hasData &&
                  usersData.connectionState != ConnectionState.waiting) {
                final users = usersData.data!.docs;

                return FutureBuilder(
                    future: usersProvider.fuUser(usersProvider.userId),
                    builder: (__, currentUser) {
                      if (currentUser.hasData &&
                          currentUser.connectionState !=
                              ConnectionState.waiting) {
                        final List friends = currentUser.data!["friends"];
                        for (final friendData in friends) {
                          bool isMember = false;
                          for (final member in members) {
                            if (member == friendData["friend"]) {
                              isMember = true;
                            }
                          }
                          if (!isMember) {
                            late final friend;
                            for (final user in users) {
                              if (friendData["friend"] == user.id) {
                                friend = user;
                              }
                            }

                            widgets.add(
                              GestureDetector(
                                onTap: () async {
                                  Navigator.of(__).pop();
                                  ScaffoldMessenger.of(__)
                                      .hideCurrentSnackBar();
                                  ScaffoldMessenger.of(__).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          "Sure to add ${friend["username"]}?"),
                                      backgroundColor: Colors.blue,
                                      action: SnackBarAction(
                                        textColor: Colors.white,
                                        label: "Add",
                                        onPressed: () async {
                                          await usersProvider.addMember(
                                              groupId, friend.id);
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: ChatItem(
                                  friend["username"],
                                  friend["image_url"],
                                  true,
                                  "user.png",
                                ),
                              ),
                            );
                          }
                        }
                        return AlertDialog(
                          scrollable: true,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: widgets,
                          ),
                          title: widgets.isEmpty
                              ? const Text(
                                  "You don't have friends not in this group",
                                )
                              : const Text("Choose the new member"),
                        );
                      }
                      return Container();
                    });
              }
              return Container();
            }),
      );
    }

    return StreamBuilder(
        stream: usersProvider.chat(groupId),
        builder: (ctx, chatData) {
          if (chatData.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (chatData.hasData) {
            final doc = chatData.data!;
            final String currentUser = usersProvider.userId;
            final bool creator = doc["creator"] == currentUser;
            bool currentIsAdmin = false;
            final List admins = doc["admins"];
            for (var i = 0; i < admins.length; i++) {
              if (currentUser == admins[i]) {
                currentIsAdmin = true;
              }
            }

            return Scaffold(
              appBar: AppBar(
                title: const Text("Group"),
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // show the group Image
                    Container(
                      height: 150,
                      width: 150,
                      margin: const EdgeInsets.all(15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: FadeInImage(
                          placeholder: const AssetImage('assets/group.jpg'),
                          image: NetworkImage(doc["groupImage"]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    //show the group name
                    Text(
                      doc["groupName"],
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //show the group members
                    Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Members",
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: currentIsAdmin
                                    ? TextAlign.end
                                    : TextAlign.center,
                              ),
                            ),
                            if (currentIsAdmin)
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                  alignment: Alignment.topRight,
                                  onPressed: () async {
                                    await _showDialog(ctx, doc["members"]);
                                  },
                                  icon: const Icon(
                                    Icons.person_add_alt_1,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Builder(
                          builder: (context) {
                            bool isAdmin(String id) {
                              bool isAdmin = false;
                              for (final admin in doc["admins"]) {
                                if (admin == id) {
                                  isAdmin = true;
                                }
                              }
                              return isAdmin;
                            }

                            final List<Widget> widgets =
                                GroupArrangement.arrange(
                              context,
                              groupId,
                              doc["members"],
                              isAdmin,
                              creator,
                            );
                            return Column(
                              children: widgets,
                            );
                          },
                        ),
                      ]),
                    ),
                    // show the exit  group button

                    GestureDetector(
                      onTap: () async {
                        if (doc["admins"].length == 1 && currentIsAdmin) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "You are the only admin it the group, Please add an admin."),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        } else {
                          await usersProvider.removeMember(
                            currentUser,
                            groupId,
                          );

                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                          await Navigator.of(context)
                              .pushReplacementNamed(ChatsScreen.routeName);
                        }
                      },
                      child: const ListTile(
                        leading: Icon(Icons.exit_to_app, color: Colors.red),
                        title: Text("Exit Group",
                            style: TextStyle(color: Colors.red)),
                      ),
                    ),
                    if (creator)
                      const Divider(
                        color: Colors.black,
                      ),
                    if (creator)
                      GestureDetector(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Are You Sure?"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    await Navigator.of(context)
                                        .pushReplacementNamed(
                                            ChatsScreen.routeName);
                                    await usersProvider.deleteChat(groupId);
                                  },
                                  child: const Text("Sure"),
                                )
                              ],
                            ),
                          );
                        },
                        child: const ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text("Delete Group",
                              style: TextStyle(color: Colors.red)),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
          //return container if the chat is downloading
          return Container();
        });
  }
}
