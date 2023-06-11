import "dart:io";

import "package:country_picker/country_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_custom_clippers/flutter_custom_clippers.dart";
import "package:libphonenumber/libphonenumber.dart";
import "package:pinput/pinput.dart";
import "image_input.dart";

class AuthForm extends StatefulWidget {
  const AuthForm(this.submit, this.scaffoldKey, this.height, {super.key});

  final Future<bool> Function(
    bool? isCode, {
    String? iso,
    String? phone,
    String? username,
    String? code,
    File? pickedImage,
  }) submit;

  final double height;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isValid = false;
  bool? _isCode = false;
  String _phone = "";
  String _code = "";
  Country _selectedCountry = Country(
    phoneCode: "20",
    countryCode: "EG",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Egypt",
    example: "Egypt",
    displayName: "Egypt",
    displayNameNoCountryCode: "Eg",
    e164Key: "e164Key",
  );
  String _userName = "";
  File? _pickedImage;

  void onSelectImage(File image) {
    _pickedImage = image;
  }

  Future<void> _trySubmit() async {
    // if its the time to enter his data
    final String? phone = await PhoneNumberUtil.normalizePhoneNumber(
        phoneNumber: _phone, isoCode: _selectedCountry.countryCode);
    if (_isCode == null) {
      if (widget.scaffoldKey.currentContext != null) {
        FocusScope.of(widget.scaffoldKey.currentContext!).unfocus();
      }
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      await widget.submit(
        null,
        username: _userName,
        pickedImage: _pickedImage,
        phone: phone,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });
      // if its the time to enter the code
    } else if (_isCode == true) {
      if (widget.scaffoldKey.currentContext != null) {
        FocusScope.of(widget.scaffoldKey.currentContext!).unfocus();
      }
      if (await widget.submit(
        true,
        code: _code,
      )) {
        setState(() {
          _isCode = null;
        });
      }
      // if its the time to enter phone number
    } else if (_isCode == false) {
      _isValid = await widget.submit(false,
          phone: phone, iso: _selectedCountry.countryCode);
      if (!_form.currentState!.validate()) {
        return;
      }
      _form.currentState!.save();
      if (widget.scaffoldKey.currentContext != null) {
        FocusScope.of(widget.scaffoldKey.currentContext!).unfocus();
      }
      setState(() {
        _isCode = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(
          minHeight: widget.height,
          maxHeight: widget.height + 300,
        ),
        child: LayoutBuilder(builder: (context, constrains) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // nice design in the top
              SizedBox(
                height: constrains.minHeight * 0.2,
                child: Stack(children: [
                  ClipPath(
                    clipper: WaveClipperOne(),
                    child: Container(
                      color: Colors.blue,
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
              ),
              SingleChildScrollView(
                child: Column(children: [
                  Card(
                    margin: const EdgeInsets.all(20),
                    elevation: 3,
                    child: AnimatedSize(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _form,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isCode == false)
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  child: TextFormField(
                                    key: const ValueKey("phone"),
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      prefixIcon: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        margin: const EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: 1,
                                          child: InkWell(
                                            onTap: () {
                                              showCountryPicker(
                                                  context: context,
                                                  countryListTheme:
                                                      CountryListThemeData(
                                                    bottomSheetHeight:
                                                        constrains.maxHeight *
                                                            0.6,
                                                  ),
                                                  onSelect: (value) {
                                                    setState(() {
                                                      _selectedCountry = value;
                                                    });
                                                  });
                                            },
                                            child: Text(
                                              "${_selectedCountry.flagEmoji}  +${_selectedCountry.phoneCode}",
                                              textAlign: TextAlign.center,
                                              // textAlign: TextAlignVertical(y: TextAlign.c),
                                            ),
                                          ),
                                        ),
                                      ),
                                      hintText: "Phone Number",
                                      hintStyle: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      border: const OutlineInputBorder(
                                          borderSide: BorderSide()),
                                    ),
                                    validator: (value) {
                                      return value == "" || value == null
                                          ? "Please enter you phone number."
                                          : !_isValid
                                              ? "PLease enter a valid phone number."
                                              : null;
                                    },
                                    onChanged: (newValue) => _phone = newValue,
                                  ),
                                ),
                              if (_isCode == true)
                                Pinput(
                                  length: 6,
                                  showCursor: true,
                                  defaultPinTheme: PinTheme(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.blue.shade200,
                                      ),
                                    ),
                                  ),
                                  onCompleted: (value) {
                                    _code = value;
                                    _trySubmit();
                                  },
                                ),
                              if (_isCode == null) ImageInput(onSelectImage),
                              if (_isCode == null)
                                Container(
                                  margin: const EdgeInsets.all(5),
                                  child: TextFormField(
                                    key: const ValueKey("username"),
                                    autocorrect: true,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    enableSuggestions: true,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      hintText: "UserName",
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                              const SizedBox(height: 12),
                              if (_isLoading)
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              if (!_isLoading && _isCode != true)
                                ElevatedButton(
                                  onPressed: _trySubmit,
                                  child: Text(
                                    _isCode == null ? "Save" : "Login",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: constrains.minHeight * 0.15,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.center,
                        height: constrains.minHeight * 0.15,
                        width: constrains.minHeight * 0.3,
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
                      height: constrains.minHeight * 0.07,
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
