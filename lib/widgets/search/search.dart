import "package:chat_app/providers/users_providers.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../../screens/chat_screen.dart";
import "../chat/chat_item.dart";

// ignore: must_be_immutable
class Search extends StatefulWidget {
  const Search(this.searchedId, {this.onlyFriends = false, super.key});
  final String searchedId;
  final bool onlyFriends;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late String lastMessage;

  String? chatId;
  final List tokenUsers = [];
  final List<String> tokenUsersIds = [];

  @override
  Widget build(BuildContext context) {
    final UsersProvider usersProvider = Provider.of<UsersProvider>(context);
    Widget usersWidget(List searchedUsers) => Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              final searchedUser = searchedUsers[index];

              return FutureBuilder(
                  future: usersProvider.isBlock(searchedUser.id),
                  builder: (context, isBlock) {
                    if (isBlock.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: index == 0
                            ? Container(
                                margin: const EdgeInsets.all(10),
                                child: const CircularProgressIndicator())
                            : Container(),
                      );
                    }
                    if (isBlock.hasData) {
                      return FutureBuilder(
                        future: usersProvider.isFriend(searchedUser.id),
                        builder: (ctx, isFriend) {
                          if (isFriend.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: index == 0
                                  ? Container(
                                      margin: const EdgeInsets.all(10),
                                      child: const CircularProgressIndicator())
                                  : Container(),
                            );
                          }
                          if (isFriend.hasData) {
                            return GestureDetector(
                              onLongPress: isFriend.data != false
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text(
                                              "Do you want to block ${searchedUser["username"]}"),
                                          actions: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: const Text(
                                                    "NO",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await usersProvider
                                                        .blockUser(
                                                            searchedUser.id);
                                                    setState(() {});
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: const Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              onTap: () async {
                                if (widget.onlyFriends == true) {
                                  setState(() {
                                    tokenUsers.add(searchedUser);
                                    tokenUsersIds.add(searchedUser.id);
                                    usersProvider
                                        .updateTokenUsers(tokenUsersIds);
                                  });
                                } else {
                                  if (!isBlock.data![0] && !isBlock.data![1]) {
                                    var result;
                                    if (isFriend.data == false) {
                                      result = await usersProvider
                                          .addChat(searchedUser.id);
                                      await usersProvider.addFriend(
                                          searchedUser.id, result.id);
                                      Navigator.of(context).pop();
                                      return;
                                    }
                                    await Navigator.of(context).pushNamed(
                                      ChatScreen.routeName,
                                      arguments: {
                                        "chatName": searchedUser["username"],
                                        "type": "private",
                                        "userId": searchedUser.id,
                                        "status": searchedUser["status"],
                                        "chatId": isFriend.data == false
                                            ? result.id
                                            : isFriend.data,
                                      },
                                    );
                                  } else {
                                    if (isBlock.data![0]) {
                                      await showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: Text(
                                              "Do you want to un block ${searchedUser["username"]}"),
                                          actions: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: const Text(
                                                    "NO",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await usersProvider.unBlock(
                                                        searchedUser.id);
                                                    Navigator.of(ctx).pop();
                                                    setState(() {});
                                                  },
                                                  child: const Text(
                                                    "Yes",
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                  }
                                }
                              },
                              child: Column(
                                children: [
                                  if (index != 0)
                                    const Divider(
                                      color: Colors.black,
                                    ),
                                  if (isFriend.data == false)
                                    ChatItem(
                                      searchedUser["username"],
                                      searchedUser["image_url"],
                                      false,
                                      "user.png",
                                      isBlock: isBlock.data![0],
                                      isHeBlock: isBlock.data![1],
                                    ),
                                  if (isFriend.data != false)
                                    StreamBuilder(
                                        stream:
                                            usersProvider.chat(isFriend.data),
                                        builder: (context, chat) {
                                          if (chat.connectionState ==
                                              ConnectionState.waiting) {}
                                          if (chat.hasData &&
                                              chat.connectionState !=
                                                  ConnectionState.waiting) {
                                            return ChatItem(
                                              searchedUser["username"],
                                              searchedUser["image_url"],
                                              true,
                                              "user.png",
                                              lastMessage: widget.onlyFriends
                                                  ? ""
                                                  : chat.data!["lastMessage"],
                                            );
                                          }
                                          return Container();
                                        }),
                                ],
                              ),
                            );
                          }
                          return Container();
                        },
                      );
                    }
                    return Text(isBlock.data.toString());
                  });
            },
            itemCount: searchedUsers.length,
          ),
        );

    return StreamBuilder(
      stream: usersProvider.users,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
          );
        }
        if (snapshot.hasData) {
          final String currentUserId = usersProvider.userId;
          final currentUser = snapshot.data!.docs
              .firstWhere((user) => user.id == currentUserId);

          var users = widget.onlyFriends
              ? snapshot.data!.docs.where((user) {
                  bool found = false;
                  for (final friend in currentUser["friends"]) {
                    if (friend["friend"] == user.id) {
                      found = true;
                    }

                    if (found) {
                      for (final tokenUser in tokenUsers) {
                        if (user.id == tokenUser.id) {
                          found = false;
                          break;
                        } else {
                          found = true;
                        }
                      }
                    }
                  }
                  return found;
                })
              : snapshot.data!.docs;

          final searchedUsers = [];
          for (final user in users) {
            user.id.startsWith(widget.searchedId) && user.id != currentUserId
                ? searchedUsers.add(user)
                : null;
          }
          if (searchedUsers.isNotEmpty || tokenUsers.isNotEmpty) {
            // add
            List<Widget> widgets = [];
            if (tokenUsers.isNotEmpty) {
              for (final tokenUser in tokenUsers) {
                widgets.add(
                  Container(
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(tokenUser["image_url"]),
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          tokenUser["username"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              tokenUsers.remove(tokenUser);
                              tokenUsersIds.remove(tokenUser.id);
                              usersProvider.updateTokenUsers(tokenUsersIds);
                            });
                          },
                          icon: const Icon(Icons.clear, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }

            return tokenUsers.isEmpty
                ? usersWidget(searchedUsers)
                : Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(width: 2, color: Colors.black26),
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xDDDDDDDD)),
                          width: double.infinity,
                          margin: const EdgeInsets.all(10),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            direction: Axis.horizontal,
                            children: widgets,
                          ),
                        ),
                        usersWidget(searchedUsers),
                      ],
                    ),
                  );
          }
          return Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(8),
                child: Text(
                  widget.onlyFriends
                      ? widget.searchedId == ""
                          ? "You don't have friends"
                          : "You haven't friends with this Id"
                      : "There is no user with this id",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
