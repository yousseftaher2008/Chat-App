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
    void showSnackBar(String content) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Can't change the $content"),
        backgroundColor: Colors.red,
      ));
    }

    TextEditingController _controller =
        TextEditingController(text: widget.username);
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
                                        child: FadeInImage(
                                          placeholder: const AssetImage(
                                              "assets/user.png"),
                                          image: NetworkImage(userImage.data!),
                                          fit: BoxFit.cover,
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
                if (_isMe)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isMe ? "Your Name" : "Name",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            suffixIcon: isIconVisible
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        usersProvider
                                            .updateUsername(_controller.text);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.done_sharp,
                                      size: 40,
                                      color: Colors.green,
                                    ),
                                  )
                                : null,
                          ),
                          onSubmitted: (value) {},
                          onTap: () {
                            isIconVisible = true;
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                if (!_isMe)
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide())),
                    child: Text(
                      widget.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _isMe ? "Your Phone" : "Profile",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(15),
                      color: Colors.black45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.phone}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _isMe ? showSnackBar("phone") : null;
                            },
                            icon: const Icon(
                              Icons.edit_off_outlined,
                              size: 40,
                            ),
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isMe ? "Your Id" : "Id",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(15),
                      color: Colors.black45,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(
                            child: Text(
                              "${widget.userId}",
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _isMe ? showSnackBar("user id") : null;
                            },
                            icon: const Icon(
                              Icons.edit_off_outlined,
                              size: 40,
                            ),
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(15),
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
