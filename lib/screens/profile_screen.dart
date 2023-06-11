import "dart:io";

import "package:chat_app/widgets/profile.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";

import "../providers/users_providers.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String routeName = "/profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userId = "";
  bool _isLoading = false;

  Future<void> takePicture(ImageSource source) async {
    setState(() {
      _isLoading = true;
    });
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);

    final File? image = await usersProvider.takePicture(
      source,
    );
    if (image != null) await usersProvider.updateUserImage(image);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UsersProvider usersProvider = Provider.of<UsersProvider>(context);

    const Widget waitingScreen = Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
    _userId = ModalRoute.of(context)!.settings.arguments.toString().trim();

    if (_userId == "null") {
      try {
        _userId = usersProvider.userId;
      } catch (_) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("An error occurred"),
                  content: const Text("Please try again"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("OK")),
                  ],
                ));
      }
    }
    final Stream<DocumentSnapshot<Map<String, dynamic>>> stream;
    try {
      stream = usersProvider.user(_userId);
    } catch (e) {
      return Container();
    }
    return StreamBuilder(
        stream: stream,
        builder: (context, usersSnapshot) {
          if (usersSnapshot.connectionState == ConnectionState.waiting) {
            return waitingScreen;
          }
          if (usersSnapshot.data != null) {
            final String username = usersSnapshot.data!["username"];
            final String phone = usersSnapshot.data!["phone"];
            return Profile(
              username,
              phone,
              _userId,
              _isLoading ? null : usersProvider.fuUserImage(_userId),
              _isLoading,
              takePicture,
              usersProvider.updateUsername,
            );
          }
          return waitingScreen;
        });
  }
}
