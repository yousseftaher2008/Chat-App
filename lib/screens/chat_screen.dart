import "package:chat_app/providers/users_providers.dart";
import "package:chat_app/screens/group_screen.dart";
import "package:provider/provider.dart";
import "../screens/profile_screen.dart";
import "../widgets/chat/messages.dart";
import "../widgets/chat/new_message.dart";
import "package:flutter/material.dart";

import "chats_screen.dart";

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static const String routeName = "/chat";
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final Map args = ModalRoute.of(context)!.settings.arguments as Map;
    final String type = args["type"];
    final String chatName = args["chatName"];
    final String chatId = args["chatId"];
    String? userId;
    String? status;
    if (type == "private") {
      userId = args["userId"];
      status = args["status"];
    }
    final UsersProvider usersProvider = Provider.of<UsersProvider>(context);

    final AppBar appBar = AppBar(
      title: type == "group"
          ? GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(GroupScreen.routeName, arguments: chatId);
              },
              child: Text(chatName),
            )
          : Column(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                    ProfileScreen.routeName,
                    arguments: userId,
                  ),
                  child: Text(
                    chatName,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  status!,
                  style: TextStyle(
                    color: status == "online"
                        ? Colors.green
                        : const Color.fromRGBO(50, 0, 0, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
      actions: [
        DropdownButton(
          underline: Container(),
          items: [
            DropdownMenuItem(
              value: "profile",
              child: Row(children: [
                const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  type == "private" ? "User Profile" : "Group info",
                  style: const TextStyle(),
                ),
              ]),
            ),
            DropdownMenuItem(
              value: type == "private" ? "block" : "exit",
              child: Row(children: [
                Icon(
                  type == "private"
                      ? Icons.person_off_rounded
                      : Icons.exit_to_app,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(type == "private" ? "Block user" : "Exit group"),
              ]),
            ),
            const DropdownMenuItem(
              value: "delete",
              child: Row(children: [
                Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Clear Messages",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ]),
            ),
          ],
          onChanged: (itemIdentifier) async {
            if (itemIdentifier == "delete") {
              await usersProvider.clearMessages(chatId);
            } else if (itemIdentifier == "block") {
              await usersProvider.blockUser(userId!);
              await Navigator.of(context)
                  .pushReplacementNamed(ChatsScreen.routeName);
            } else if (itemIdentifier == "profile") {
              await Navigator.of(context).pushNamed(
                  type == "private"
                      ? ProfileScreen.routeName
                      : GroupScreen.routeName,
                  arguments: type == "private" ? userId! : chatId);
            }
          },
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).primaryIconTheme.color,
          ),
        )
      ],
    );
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: SizedBox(
          height: mediaQuery.size.height -
              mediaQuery.padding.top -
              appBar.preferredSize.height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: Messages(chatId)),
              NewMessage(chatId),
            ],
          ),
        ),
      ),
    );
  }
}
