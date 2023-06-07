import "package:chat_app/providers/users_providers.dart";
import "package:chat_app/screens/auth_screen.dart";
import "package:chat_app/screens/new_group_screen.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../widgets/chat/chats.dart";
import "profile_screen.dart";
import "search_screen.dart";

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});
  static const routeName = "/chats";
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: const Text("Chat App"),
        actions: [
          DropdownButton(
            underline: Container(),
            items: const [
              DropdownMenuItem(
                value: "group",
                child: Row(children: [
                  Icon(
                    Icons.group_add,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("New Group"),
                ]),
              ),
              DropdownMenuItem(
                value: "profile",
                child: Row(children: [
                  Icon(
                    Icons.manage_accounts,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("My Profile"),
                ]),
              ),
              DropdownMenuItem(
                value: "logout",
                child: Row(children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("logout"),
                ]),
              ),
            ],
            onChanged: (itemIdentifier) async {
              if (itemIdentifier == "logout") {
                await Provider.of<UsersProvider>(context, listen: false)
                    .setStatus("offline", "out");
                await FirebaseAuth.instance.signOut();
                await Navigator.of(_scaffold.currentContext!)
                    .pushReplacementNamed(AuthScreen.routeName);
              } else if (itemIdentifier == "profile") {
                await Navigator.of(_scaffold.currentContext!)
                    .pushNamed(ProfileScreen.routeName);
              } else if (itemIdentifier == "group") {
                await Navigator.of(_scaffold.currentContext!)
                    .pushNamed(NewGroupScreen.routeName)
                    .then((value) {
                  Provider.of<UsersProvider>(_scaffold.currentContext!,
                          listen: false)
                      .updateTokenUsers([]);
                });
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
          )
        ],
      ),
      body: const Chats(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(SearchScreen.routeName),
        child: const Icon(Icons.person_add_alt_1_rounded),
      ),
    );
  }
}
