import "package:chat_app/screens/group_screen.dart";
import "../screens/profile_screen.dart";
import "../widgets/chat/messages.dart";
import "../widgets/chat/new_message.dart";
import "package:flutter/material.dart";

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
                if (type == "private")
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
