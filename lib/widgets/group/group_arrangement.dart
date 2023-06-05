import 'package:chat_app/providers/users_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/chat_screen.dart';
import '../../screens/profile_screen.dart';
import '../chat/chat_item.dart';

class GroupArrangement {
  static List<Widget> arrange(
    BuildContext context,
    String groupId,
    List<dynamic> members,
    Function(String id) isAdmin,
    bool currentCreator,
  ) {
    List<Widget> widgets = [];
    final UsersProvider usersProvider = Provider.of<UsersProvider>(context);
    final String currentUserId = usersProvider.userId;
    Future<void> showEdit(String username, String id, String adminFun) async {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(
            username,
            textAlign: TextAlign.center,
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton.icon(
                label: Text(
                  "$adminFun Admin",
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),
                icon: const Icon(
                  Icons.upgrade_outlined,
                  color: Colors.green,
                ),
                onPressed: () async {
                  adminFun == "Make"
                      ? await usersProvider.makeAdmin(id, groupId)
                      : await usersProvider.dismissAdmin(id, groupId);
                  Navigator.of(ctx).pop();
                },
              ),
              TextButton.icon(
                label: const Text(
                  "Remove",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                icon: const Icon(
                  Icons.person_remove_alt_1,
                  color: Colors.red,
                ),
                onPressed: () async {
                  await usersProvider.removeMember(id, groupId);
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        ),
      );
    }

    //get the current user
    for (int i = 0; i < members.length; i++) {
      final member = members[i];
      final admin = isAdmin(member);
      if (member == currentUserId) {
        widgets.add(
          GestureDetector(
            child: FutureBuilder(
                future: usersProvider.fuUserImage(currentUserId),
                builder: (context, image) {
                  if (image.hasData &&
                      image.connectionState != ConnectionState.waiting) {
                    return ChatItem(
                      "You",
                      image.data!,
                      true,
                      "user.png",
                      lastMessage: "",
                      isAdmin: admin,
                    );
                  }
                  return Container();
                }),
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: TextButton.icon(
                  label: const Text("That is you"),
                  icon: const Icon(Icons.tag_faces),
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    Navigator.of(context).pushNamed(
                      ProfileScreen.routeName,
                      arguments: member,
                    );
                  },
                ),
                duration: const Duration(seconds: 1),
                backgroundColor: Colors.blue,
              ));
            },
          ),
        );
      }
    }

    //get the admins
    for (final member in members) {
      final admin = isAdmin(member);
      if (admin && member != currentUserId) {
        widgets.add(
          StreamBuilder(
              stream: usersProvider.user(member),
              builder: (context, userData) {
                if (userData.hasData &&
                    userData.connectionState != ConnectionState.waiting) {
                  final user = userData.data!;
                  return FutureBuilder(
                    future: usersProvider.isBlock(member),
                    builder: (ctx, isBlockData) {
                      if (isBlockData.hasData &&
                          isBlockData.connectionState !=
                              ConnectionState.waiting) {
                        final isBlock = isBlockData.data!;

                        return FutureBuilder(
                            future: usersProvider.isFriend(member),
                            builder: (context, isFriendData) {
                              if (isFriendData.hasData &&
                                  isFriendData.connectionState !=
                                      ConnectionState.waiting) {
                                final isFriend = isFriendData.data!;

                                if (isFriend == false) {
                                  return GestureDetector(
                                    onLongPress: currentCreator
                                        ? () async {
                                            await showEdit(user["username"],
                                                user.id, "Dismiss as");
                                          }
                                        : null,
                                    child: ChatItem(
                                      user["username"],
                                      user["image_url"],
                                      isFriend,
                                      "user.png",
                                      isAdmin: admin,
                                      isBlock: isBlock[0],
                                      isHeBlock: isBlock[1],
                                    ),
                                  );
                                } else {
                                  return GestureDetector(
                                    child: ChatItem(
                                      user["username"],
                                      user["image_url"],
                                      true,
                                      "user.png",
                                      lastMessage: "",
                                      isAdmin: admin,
                                      isBlock: isBlock[0],
                                      isHeBlock: isBlock[1],
                                    ),
                                    onLongPress: currentCreator
                                        ? () async {
                                            await showEdit(user["username"],
                                                user.id, "Dismiss as");
                                          }
                                        : null,
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                      Navigator.of(context).pushNamed(
                                        ChatScreen.routeName,
                                        arguments: {
                                          "chatName": user["username"],
                                          "image": user["image_url"],
                                          "type": "private",
                                          "userId": member,
                                          "status": user["status"],
                                          "chatId": isFriend,
                                        },
                                      );
                                    },
                                  );
                                }
                              }
                              return Container();
                            });
                      }
                      return Container();
                    },
                  );
                }
                return Container();
              }),
        );
      }
    }

    //get the members and not blocked
    for (final member in members) {
      final admin = isAdmin(member);
      if (!admin && member != currentUserId) {
        widgets.add(
          FutureBuilder(
              future: usersProvider.isFriend(member),
              builder: (context, isFriendData) {
                if (isFriendData.hasData &&
                    isFriendData.connectionState != ConnectionState.waiting) {
                  final isFriend = isFriendData.data!;
                  return StreamBuilder(
                      stream: usersProvider.user(member),
                      builder: (context, userData) {
                        if (userData.hasData &&
                            userData.connectionState !=
                                ConnectionState.waiting) {
                          final user = userData.data!;
                          return FutureBuilder(
                            future: usersProvider.isBlock(member),
                            builder: (ctx, isBlockData) {
                              if (isBlockData.hasData &&
                                  isBlockData.connectionState !=
                                      ConnectionState.waiting) {
                                final isBlock = isBlockData.data!;
                                if (isBlock == false) {
                                  if (isFriend == false) {
                                    return GestureDetector(
                                      onLongPress: currentCreator
                                          ? () async {
                                              await showEdit(user["username"],
                                                  user.id, "Make");
                                            }
                                          : null,
                                      child: ChatItem(
                                        user["username"],
                                        user["image_url"],
                                        true,
                                        "user.png",
                                        lastMessage: "",
                                        isAdmin: admin,
                                        isBlock: isBlock[0],
                                        isHeBlock: isBlock[1],
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      child: ChatItem(
                                        user["username"],
                                        user["image_url"],
                                        true,
                                        "user.png",
                                        lastMessage: "",
                                        isAdmin: admin,
                                        isBlock: isBlock[0],
                                        isHeBlock: isBlock[1],
                                      ),
                                      onLongPress: currentCreator
                                          ? () async {
                                              await showEdit(user["username"],
                                                  user.id, "Make");
                                            }
                                          : null,
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                        Navigator.of(context).pushNamed(
                                          ChatScreen.routeName,
                                          arguments: {
                                            "chatName": user["username"],
                                            "image": user["image_url"],
                                            "type": "private",
                                            "userId": member,
                                            "status": user["status"],
                                            "chatId": isFriend,
                                          },
                                        );
                                      },
                                    );
                                  }
                                }
                              }
                              return Container();
                            },
                          );
                        }
                        return Container();
                      });
                }
                return Container();
              }),
        );
      }
    }

    //get the blocked members
    for (final member in members) {
      final admin = isAdmin(member);
      if (!admin && member != currentUserId) {
        widgets.add(
          FutureBuilder(
            future: usersProvider.isBlock(member),
            builder: (ctx, isBlockData) {
              if (isBlockData.hasData &&
                  isBlockData.connectionState != ConnectionState.waiting) {
                final isBlock = isBlockData.data!;
                if (isBlock != false) {
                  return StreamBuilder(
                      stream: usersProvider.user(member),
                      builder: (context, userData) {
                        if (userData.hasData &&
                            userData.connectionState !=
                                ConnectionState.waiting) {
                          final user = userData.data!;
                          return GestureDetector(
                            onLongPress: currentCreator
                                ? () async {
                                    await showEdit(
                                        user["username"], user.id, "Make");
                                  }
                                : null,
                            child: ChatItem(
                              user["username"],
                              user["image_url"],
                              false,
                              "user.png",
                              isBlock: isBlock[0],
                              isHeBlock: isBlock[1],
                            ),
                          );
                        }
                        return Container();
                      });
                }
              }
              return Container();
            },
          ),
        );
      }
    }

    //return the widgets list and the current user index
    return widgets;
  }
}
