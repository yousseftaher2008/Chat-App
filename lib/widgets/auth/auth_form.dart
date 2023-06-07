import "dart:io";

import "package:flutter/material.dart";
import "image_input.dart";

class AuthForm extends StatefulWidget {
  const AuthForm(this.submit, this.scaffoldKey, {super.key});
  final Future<void> Function(
    String email,
    String password,
    String username,
    File? pickedImage,
    bool isLogin,
  ) submit;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _form = GlobalKey<FormState>();

  File? _pickedImage;
  bool _isLogin = true;
  bool _isLoading = false;
  String _email = "";
  String _userName = "";
  String _password = "";
  String _password2 = "";

  void onSelectImage(File image) {
    _pickedImage = image;
  }

  Future<void> _trySubmit() async {
    if (!_form.currentState!.validate()) {
      return;
    }
    if (_pickedImage == null && !_isLogin) {
      _pickedImage = File("unknown");
    }
    if (_password != _password2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("The password must be equal to password again"),
      ));
      return;
    }
    print("$_password $_password2");
    _form.currentState!.save();
    if (widget.scaffoldKey.currentContext != null) {
      FocusScope.of(widget.scaffoldKey.currentContext!).unfocus();
    }
    setState(() {
      _isLoading = true;
    });
    await widget.submit(
      _email.trim(),
      _password.trim(),
      _userName.trim(),
      _pickedImage,
      _isLogin,
    );

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) ImageInput(onSelectImage),
                    TextFormField(
                      key: const ValueKey("email"),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: "Email Address",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                      validator: (value) => value == "" || value == null
                          ? "Please enter an email address"
                          : !(value.contains("@") && value.contains(".com"))
                              ? "Please enter a valid email address"
                              : null,
                      onSaved: (newValue) {
                        if (newValue == null) return;
                        _email = newValue;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey("username"),
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: true,
                        decoration: const InputDecoration(
                          labelText: "UserName",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        validator: (value) => value == "" || value == null
                            ? "Please enter a user name"
                            : value.length < 5
                                ? "Username cannot be less than 5 characters"
                                : value.length > 25
                                    ? "Username cannot be longer than 25 characters"
                                    : null,
                        onSaved: (newValue) {
                          if (newValue == null) return;
                          _userName = newValue;
                        },
                      ),
                    TextFormField(
                      key: const ValueKey("password"),
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      obscureText: true,
                      validator: (value) => value == "" || value == null
                          ? "Please enter a password"
                          : value.length < 8
                              ? "The user password must be at least 8 characters"
                              : null,
                      onSaved: (newValue) {
                        if (newValue == null) return;
                        _password = newValue;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey("password2"),
                        decoration: const InputDecoration(
                          labelText: "Password Again",
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        obscureText: true,
                        validator: (value) => value == "" || value == null
                            ? "Please enter a password agin"
                            : value.length < 8
                                ? "The user password must be at least 8 characters"
                                : null,
                        onSaved: (newValue) {
                          if (newValue == null) return;
                          _password2 = newValue;
                        },
                      ),
                    const SizedBox(height: 12),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    if (!_isLoading)
                      ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? "Login" : "SignUp"),
                      ),
                    if (!_isLoading)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? "Create new account"
                            : "I have already an account"),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
