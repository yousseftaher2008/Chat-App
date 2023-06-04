import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class AuthPhone extends StatefulWidget {
  const AuthPhone({super.key});

  @override
  State<AuthPhone> createState() => _AuthPhoneState();
}

class _AuthPhoneState extends State<AuthPhone> {
  String phoneNumber = "";
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            TextField(
              keyboardType: TextInputType.phone,
              onChanged: (value) => phoneNumber = value,
            ),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: "+201092474366",
                    verificationCompleted: (PhoneAuthCredential phone) {
                      // print(phone);
                    },
                    verificationFailed: (FirebaseAuthException exception) {
                      // print("that's the exception $exception");
                    },
                    codeSent: (String smsCode, int? resendToken) {
                      // print(
                      // "the code is sent ===========>$smsCode ... $resendToken");
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {
                      // print(verificationId);
                    },
                  );
                },
                child: const Text("add"))
          ],
        ),
      );
}
