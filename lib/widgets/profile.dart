import "package:chat_app/screens/chats_screen.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";

import "../providers/users_providers.dart";
import "../screens/show_image_screen.dart";

class Profile extends StatefulWidget {
  const Profile(this.username, this.phone, this.userId, this.image,
      this.isLoading, this.takePicture, this.updateUsername,
      {super.key});
  final String username;
  final String phone;
  final String userId;
  final Future<String>? image;
  final bool isLoading;
  final Function(ImageSource) takePicture;
  final Function(String) updateUsername;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isIconVisible = false;
  @override
  Widget build(BuildContext context) {
    final UsersProvider usersProvider = Provider.of<UsersProvider>(context);
    final _form = GlobalKey<FormState>();
    String _userName = "";
    TextEditingController _controller = TextEditingController();
    _controller.text = widget.username;
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length));
    final bool _isMe = usersProvider.userId == widget.userId;
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
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  margin: const EdgeInsets.all(15),
                  child: Stack(
                      // alignment: Alignment,
                      children: [
                        if (widget.isLoading)
                          CircleAvatar(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                Text(
                                  "Loading...",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                )
                              ],
                            ),
                            backgroundColor: Colors.transparent,
                            radius: 90,
                          ),
                        if (!widget.isLoading)
                          FutureBuilder(
                              future: widget.image!,
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
                                        "id": widget.userId,
                                      },
                                    );
                                  },
                                  child: Hero(
                                    tag: widget.userId,
                                    child: SizedBox(
                                      height: 150,
                                      width: 150,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(75),
                                        child: userImage.data! != "unknown" &&
                                                userImage.data! != "gUnknown"
                                            ? FadeInImage(
                                                placeholder: const AssetImage(
                                                    "assets/user.png"),
                                                image: NetworkImage(
                                                    userImage.data!),
                                                fit: BoxFit.cover,
                                              )
                                            : Center(
                                                child: Icon(
                                                  userImage == "gUnknown"
                                                      ? Icons.groups
                                                      : Icons.person,
                                                  size: 150,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        if (_isMe && !widget.isLoading)
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
                                            await widget.takePicture(
                                                ImageSource.gallery);
                                          },
                                          icon: const Icon(Icons.image),
                                          label: const Text("Gallery"),
                                        ),
                                        TextButton.icon(
                                          onPressed: () async {
                                            Navigator.of(ctx).pop();
                                            await widget.takePicture(
                                                ImageSource.camera);
                                          },
                                          icon: const Icon(
                                              Icons.camera_alt_outlined),
                                          label: const Text("Camera"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                          ),
                      ]),
                ),
                _isMe
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Your Name",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.all(5),
                            child: Form(
                              key: _form,
                              child: TextFormField(
                                controller: _controller,
                                validator: (value) => value ==
                                            widget.username ||
                                        value == null ||
                                        value == ""
                                    ? "Please enter a new username"
                                    : value.length < 2 || value.length > 20
                                        ? "The username must be at least 2 and most 20 characters"
                                        : null,
                                decoration: InputDecoration(
                                  suffixIcon: isIconVisible
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.done_sharp,
                                            size: 40,
                                            color: Colors.green,
                                          ),
                                          onPressed: () {
                                            if (_form.currentState!
                                                .validate()) {
                                              FocusScope.of(context).unfocus();
                                              usersProvider
                                                  .updateUsername(_userName);
                                            }
                                          },
                                        )
                                      : null,
                                ),
                                onChanged: (value) {
                                  _userName = value;
                                },
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
                                  usersProvider.updateUsername(value);
                                },
                                onTap: () {
                                  isIconVisible = true;
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          widget.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                _isMe
                    ? Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        color: Colors.black45,
                        child: Container(
                          width: double.infinity,
                          child: Text(
                            "phone: ${widget.phone}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          widget.phone,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontSize: 20,
                          ),
                        ),
                      ),
                _isMe
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            height: 3,
                            width: double.infinity,
                            color: Colors.black,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            color: Colors.black45,
                            width: double.infinity,
                            child: FittedBox(
                              child: Text(
                                "ID: ${widget.userId}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: double.infinity,
                        child: FittedBox(
                          child: Text("ID: ${widget.userId}"),
                        ),
                      ),
                Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: double.infinity,
                  color: Colors.black,
                ),
                Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  color: Colors.red[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isMe ? "Log out" : "Block user",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: _isMe
                            ? () async {}
                            : () async {
                                await usersProvider.blockUser(widget.userId);
                                await Navigator.of(context)
                                    .pushReplacementNamed(
                                        ChatsScreen.routeName);
                              },
                        icon: Icon(
                          _isMe ? Icons.logout : Icons.block,
                          size: 40,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
