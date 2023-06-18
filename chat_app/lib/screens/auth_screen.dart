import "dart:io";

import "package:chat_app/providers/users_providers.dart";
import "package:libphonenumber/libphonenumber.dart";
import "package:provider/provider.dart";

import "../widgets/auth/auth_form.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";

import "chats_screen.dart";

// ignore: must_be_immutable
class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});
  static const routeName = "/auth_screen";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late PhoneAuthCredential credential;

  late String verificationId;
  late BuildContext ctx;

  late UserCredential authResult;

  Future<bool> _submit(
    bool? isCode, {
    String? iso,
    String? phone,
    String? username,
    String? code,
    File? pickedImage,
  }) async {
    // if its the step when the user enter his data
    if (isCode == null) {
      pickedImage ??= File("unknown");
      try {
        authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        String url = "";
        if (pickedImage.path == "unknown") {
          final ref = FirebaseStorage.instance
              .ref()
              .child("users_images")
              .child("user.png");

          url = await ref.getDownloadURL();
        } else {
          final UsersProvider usersProvider =
              Provider.of(_scaffoldKey.currentContext!, listen: false);
          url = await usersProvider.sendFile(pickedImage, authResult.user!.uid);
          return false;
        }
        await FirebaseFirestore.instance
            .collection("/users")
            .doc(authResult.user!.uid)
            .set({
          "username": username,
          "friends": [],
          "blocks": [],
          "status": "online",
          "phone": phone,
          "image_url": url,
        });
        await Navigator.of(_scaffoldKey.currentContext!)
            .pushReplacementNamed(ChatsScreen.routeName);
        return true;
      } on FirebaseAuthException catch (err) {
        String message = "An error occurred, please try again";
        if (err.message != null) {
          message = err.message!;
        }
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .hideCurrentSnackBar();
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red,
          ),
        );
      } catch (err) {
        String message = "An error occurred, please try again";
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .hideCurrentSnackBar();
        ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 5),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    } else if (isCode == true) {
      try {
        credential = PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: code!);
        return true;
      } catch (e) {
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .hideCurrentSnackBar();
        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
            .showSnackBar(SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.red,
        ));
        return false;
      }
    }
    // if its the time to enter phone number
    else {
      bool? isNoError;
      bool isValid = await PhoneNumberUtil.isValidPhoneNumber(
              phoneNumber: phone!, isoCode: iso!) ??
          false;
      if (!isValid) {
        return false;
      }
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {},
        codeSent: (String smsCode, int? resendToken) {
          isNoError = true;
          verificationId = smsCode;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        verificationFailed: (FirebaseAuthException exception) {
          ScaffoldMessenger.of(_scaffoldKey.currentContext!)
              .hideCurrentSnackBar();
          ScaffoldMessenger.of(_scaffoldKey.currentContext!)
              .showSnackBar(SnackBar(
            content: Text(exception.message.toString()),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ));
          isNoError = false;
        },
      );
      while (isNoError == null) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      return isValid && isNoError == true;
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    final double mediaQuery = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: AuthForm(_submit, _scaffoldKey, mediaQuery),
    );
  }
}
