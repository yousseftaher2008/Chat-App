import "dart:io";

import "package:chat_app/providers/users_providers.dart";
import "package:provider/provider.dart";

import "../widgets/auth/auth_form.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";

import "chats_screen.dart";

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const routeName = "/auth_screen";
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> _submit(
    String email,
    String password,
    String username,
    File? pickedImage,
    bool isLogin,
  ) async {
    final auth = FirebaseAuth.instance;
    final authResult;
    try {
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String url = "";
        if (pickedImage == null || pickedImage.path == "unknown") {
          final ref = FirebaseStorage.instance
              .ref()
              .child("users_images")
              .child("user.png");

          url = await ref.getDownloadURL();
        } else if (pickedImage.path != "unknown") {
          final UsersProvider usersProvider =
              Provider.of(context, listen: false);
          url = await usersProvider.sendFile(pickedImage, authResult.user.uid);
        }
        await FirebaseFirestore.instance
            .collection("/users")
            .doc(authResult.user.uid)
            .set({
          "username": username,
          "friends": [],
          "blocks": [],
          "status": "online",
          "email": email,
          "image_url": url,
        });
      }
      await Navigator.of(context).pushReplacementNamed(ChatsScreen.routeName);
    } on FirebaseAuthException catch (err) {
      String message = "An error occurred, please try again";
      if (err.message != null) {
        message = err.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (err) {
      String message = "An error occurred, please try again";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double mediaQuery = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: AuthForm(_submit, _scaffoldKey, mediaQuery),
    );
  }
}
