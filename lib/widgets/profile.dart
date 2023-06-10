import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";

import "../providers/users_providers.dart";
import "../screens/show_image_screen.dart";

class Profile extends StatelessWidget {
  const Profile(this.username, this.email, this.userId, this.image,
      this.isLoading, this.takePicture, this.updateUsername,
      {super.key});
  final String username;
  final String email;
  final String userId;
  final Future<String>? image;
  final bool isLoading;
  final Function(ImageSource) takePicture;
  final Function(String) updateUsername;

  @override
  Widget build(BuildContext context) {
    final UsersProvider usersProvider = Provider.of<UsersProvider>(context);

    void showSnackBar(String content) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Can't change the $content"),
      ));
    }

    final _form = GlobalKey<FormState>();
    TextEditingController _controller = TextEditingController(text: username);
    final bool _isMe = usersProvider.userId == userId;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isMe ? "Your Profile" : "Profile"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(children: [
                  if (isLoading)
                    CircleAvatar(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                          Text(
                            "Loading...",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        ],
                      ),
                      backgroundColor: Colors.transparent,
                      radius: 90,
                    ),
                  if (!isLoading)
                    FutureBuilder(
                        future: image!,
                        builder: (context, userImage) {
                          if (userImage.connectionState ==
                              ConnectionState.waiting) {
                            return const CircleAvatar(
                              child: CircularProgressIndicator(),
                              backgroundColor: Colors.transparent,
                              radius: 90,
                            );
                          }
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                ShowImageScreen.routeName,
                                arguments: {
                                  "image": userImage.data,
                                  "id": userId,
                                },
                              );
                            },
                            child: Hero(
                              tag: userId,
                              child: SizedBox(
                                height: 150,
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(75),
                                  child: FadeInImage(
                                    placeholder:
                                        const AssetImage("assets/user.png"),
                                    image: NetworkImage(userImage.data!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  if (_isMe && !isLoading)
                    CircleAvatar(
                      child: IconButton(
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Take an Image"),
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    onPressed: () async {
                                      Navigator.of(ctx).pop();
                                      await takePicture(ImageSource.gallery);
                                    },
                                    icon: const Icon(Icons.image),
                                    label: const Text("Gallery"),
                                  ),
                                  TextButton.icon(
                                    onPressed: () async {
                                      Navigator.of(ctx).pop();
                                      await takePicture(ImageSource.camera);
                                    },
                                    icon: const Icon(Icons.camera_alt_outlined),
                                    label: const Text("Camera"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                ]),
                GestureDetector(
                  onLongPress: () async {
                    _isMe
                        ? await showDialog(
                            context: context,
                            builder: (ctx) => SingleChildScrollView(
                              child: AlertDialog(
                                title: const Text("Change Your name"),
                                content: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Form(
                                      key: _form,
                                      child: TextFormField(
                                        validator: (value) => value == null
                                            ? "Please enter a new user name"
                                            : value.length < 5
                                                ? "Username cannot be less than 5 characters"
                                                : value.length > 12
                                                    ? "Username cannot be longer than 12 characters"
                                                    : null,
                                        controller: _controller,
                                        decoration: const InputDecoration(
                                            labelText: "New name"),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        TextButton(
                                          child: const Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text("Save"),
                                          onPressed: () {
                                            if (_form.currentState != null &&
                                                _form.currentState!
                                                    .validate()) {
                                              Navigator.of(context).pop();
                                              updateUsername(_controller.text);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : null;
                  },
                  child: Text(
                    username,
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
                GestureDetector(
                  onLongPress: () {
                    _isMe ? showSnackBar("email") : null;
                  },
                  child: Text(
                    "Email: $email",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
                    ),
                  ),
                ),
                FittedBox(
                  child: GestureDetector(
                    onLongPress: () {
                      _isMe ? showSnackBar("user id") : null;
                    },
                    child: Text(
                      "Id: $userId",
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
