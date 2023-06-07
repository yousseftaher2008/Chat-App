import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_custom_clippers/flutter_custom_clippers.dart";
import "image_input.dart";

class AuthForm extends StatefulWidget {
  const AuthForm(this.submit, this.scaffoldKey, this.height, {super.key});
  final double height;
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
  bool isVisible = false;
  bool isVisible2 = false;
  bool isError = false;
  final List<bool> _selectedFruits = <bool>[true, false];
  void onSelectImage(File image) {
    _pickedImage = image;
  }

  Future<void> _trySubmit() async {
    if (!_form.currentState!.validate()) {
      if (!_isLogin) {
        setState(() {
          isError = true;
        });
      }
      return;
    }
    if (_pickedImage == null && !_isLogin) {
      _pickedImage = File("unknown");
    }
    if ((_password != _password2) && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("The password must be equal to password again"),
      ));
      return;
    }
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
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: widget.height,
        child: LayoutBuilder(builder: (context, constrains) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: constrains.maxHeight * 0.2,
                child: Stack(children: [
                  ClipPath(
                    clipper: WaveClipperOne(),
                    child: Container(
                      color: Colors.blue,
                    ),
                  ),
                  Center(
                    child: Text(
                      _isLogin ? "Login" : "Sign up",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
              ),
              Column(children: [
                ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    setState(() {
                      // The button that is tapped is set to true, and the others to false.
                      for (int i = 0; i < _selectedFruits.length; i++) {
                        _selectedFruits[i] = (i == index);
                      }
                      _isLogin = index == 0;
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedBorderColor: Colors.blue,
                  selectedColor: Colors.white,
                  fillColor: Colors.blue[300],
                  color: Colors.blue,
                  borderColor: Colors.blue[200],
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  isSelected: _selectedFruits,
                  children: const [
                    Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Sign up",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Card(
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!_isLogin) ImageInput(onSelectImage),
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: TextFormField(
                              key: const ValueKey("email"),
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              enableSuggestions: false,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                hintText: "Email Address",
                                hintStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide()),
                              ),
                              validator: (value) => value == "" || value == null
                                  ? "Please enter an email address"
                                  : !(value.contains("@") &&
                                          value.contains(".com"))
                                      ? "Please enter a valid email address"
                                      : null,
                              onSaved: (newValue) {
                                if (newValue == null) return;
                                _email = newValue;
                              },
                            ),
                          ),
                          if (!_isLogin)
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: TextFormField(
                                key: const ValueKey("username"),
                                autocorrect: true,
                                textCapitalization: TextCapitalization.words,
                                enableSuggestions: true,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: "UserName",
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.bold),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide()),
                                ),
                                validator: (value) => value == "" ||
                                        value == null
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
                            ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: TextFormField(
                              key: const ValueKey("password"),
                              onTap: () {},
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                ),
                                hintText: "Password",
                                prefixIcon: const Icon(Icons.lock),
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                border: const OutlineInputBorder(
                                    borderSide: BorderSide()),
                              ),
                              obscureText: !isVisible,
                              validator: (value) => value == "" || value == null
                                  ? "Please enter a password"
                                  : value.length < 8
                                      ? "The user password must be at least 8 characters"
                                      : null,
                              onChanged: (newValue) {
                                _password = newValue;
                              },
                            ),
                          ),
                          if (!_isLogin)
                            Container(
                              margin: const EdgeInsets.all(5),
                              child: TextFormField(
                                key: const ValueKey("password2"),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(isVisible2
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        isVisible2 = !isVisible2;
                                      });
                                    },
                                  ),
                                  prefixIcon: const Icon(Icons.lock),
                                  hintText: "Password Again",
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide()),
                                ),
                                obscureText: !isVisible2,
                                validator: (value) => value == "" ||
                                        value == null
                                    ? "Please enter a password agin"
                                    : value.length < 8
                                        ? "The user password must be at least 8 characters"
                                        : null,
                                onChanged: (newValue) {
                                  _password2 = newValue;
                                },
                              ),
                            ),
                          const SizedBox(height: 12),
                          if (_isLoading)
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                          if (!_isLoading)
                            ElevatedButton(
                              onPressed: _trySubmit,
                              child: Text(_isLogin ? "Login" : "Sign up"),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
              if (!isError || _isLogin)
                SizedBox(
                  height: constrains.maxHeight * 0.15,
                  child: Stack(
                    children: [
                      Container(
                        height: double.infinity,
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          alignment: Alignment.center,
                          height: constrains.maxHeight * 0.15,
                          width: constrains.maxHeight * 0.3,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                "assets/join.png",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        height: constrains.maxHeight * 0.07,
                        width: constrains.maxWidth,
                        child: ClipPath(
                          clipper: WaveClipperTwo(reverse: true),
                          child: Container(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
