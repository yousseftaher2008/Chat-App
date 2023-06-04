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
                        child: Container(
                            margin: const EdgeInsets.all(10),
                            child: const CircularProgressIndicator()),
                      );
                    }
                    if (isBlock.hasData) {
                      return FutureBuilder(
                        future: usersProvider.isFriend(searchedUser.id),
                        builder: (ctx, isFriend) {
                          if (isFriend.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Container(
                                  margin: const EdgeInsets.all(10),
                                  child: const CircularProgressIndicator()),
                            );
                          }
                          if (isFriend.hasData) {
                            return GestureDetector(
                              onTap: () async {
                                if (widget.onlyFriends) {
                                  setState(() {
                                    tokenUsers.add(searchedUser);
                                  });
                                } else {
                                  if (isBlock.data! == false) {
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
                                  }
                                }
                              },
                              child: isFriend.data == false
                                  ? ChatItem(
                                      searchedUser["username"],
                                      searchedUser["image_url"],
                                      false,
                                      "user.png",
                                      isBlock: isBlock.data,
                                    )
                                  : StreamBuilder(
                                      stream: usersProvider.chat(isFriend.data),
                                      builder: (context, chat) {
                                        if (chat.hasData &&
                                            chat.connectionState !=
                                                ConnectionState.waiting) {
                                          return ChatItem(
                                            searchedUser["username"],
                                            searchedUser["image_url"],
                                            true,
                                            "user.png",
                                            lastMessage:
                                                chat.data!["lastMessage"],
                                            isBlock: isBlock.data,
                                          );
                                        }
                                        return Container();
                                      }),
                            );
                          }
                          return Container();
                        },
                      );
                    }
                    return Container();
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
                Text("Loading..."),
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
            List<Widget> widgets = [];
            if (tokenUsers.isNotEmpty) {
              for (final tokenUser in tokenUsers) {
                widgets.add(
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(tokenUser["image_url"]),
                          backgroundColor: Colors.transparent,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          tokenUser["username"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                tokenUsers.remove(tokenUser);
                              });
                            },
                            icon: const Icon(Icons.clear))
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
                            border: Border.all(width: 2, color: Colors.black),
                          ),
                          margin: const EdgeInsets.all(5),
                          /*
                          todo:
                          add a child property with the best view 
                          */
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: widgets,
                              ),
                            ],
                          ),
                        ),
                        usersWidget(searchedUsers),
                      ],
                    ),
                  );
          }
          return Center(
            child: Container(
              margin: const EdgeInsets.all(8),
              child: const Text("There is no user with this id"),
            ),
          );
        }
        return Container();
      },
    );
  }
}
