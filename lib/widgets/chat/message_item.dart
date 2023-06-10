import "package:chat_app/providers/users_providers.dart";
import "package:chat_app/screens/profile_screen.dart";
import "package:chat_app/screens/show_image_screen.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";

class MessageItem extends StatelessWidget {
  const MessageItem(this.message, this.userId, this.userName, this.isPhoto,
      this.isGroup, this.isPreviousSame, this.isNextSame, this.deleteMessage,
      {super.key});

  final String message;
  final String userId;
  final String userName;
  final bool isPhoto;
  final bool isGroup;
  final bool isPreviousSame;
  final bool isNextSame;
  final Function deleteMessage;

  @override
  Widget build(BuildContext context) {
    final UsersProvider usersProvider = Provider.of<UsersProvider>(context);
    final bool isMe = usersProvider.userId == userId;

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isMe)
          // the user image for
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProfileScreen.routeName, arguments: userId);
            },
            child: Container(
              margin: const EdgeInsets.only(
                left: 10,
              ),
              child: StreamBuilder(
                  stream: usersProvider.stUserImage(userId),
                  builder: (context, userImage) {
                    if (userImage.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (userImage.hasData && (!isMe && !isPreviousSame)) {
                      return Hero(
                        tag: userImage.data!,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FadeInImage(
                              placeholder: const AssetImage("assets/user.png"),
                              image: NetworkImage(userImage.data!["image_url"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    }
                    return Container(
                      height: 40,
                      width: 40,
                    );
                  }),
            ),
          ),

        //the user message
        GestureDetector(
          onLongPress: isMe
              ? () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                    child: TextButton.icon(
                                  label: const Text(
                                    "Delete Message",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    deleteMessage();
                                    Navigator.of(ctx).pop();
                                  },
                                )),
                              ],
                            ),
                          ));
                }
              : null,
          onTap: isPhoto
              ? () {
                  Navigator.of(context)
                      .pushNamed(ShowImageScreen.routeName, arguments: {
                    "image": message,
                    "id": userId,
                  });
                }
              : null,
          child: Container(
            //style for the message
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: (isPreviousSame || !isMe)
                    ? const Radius.circular(12)
                    : const Radius.circular(0),
                topLeft: (!isPreviousSame && !isMe)
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
                bottomRight: const Radius.circular(12),
                bottomLeft: const Radius.circular(12),
              ),
              color: isPhoto
                  ? Colors.transparent
                  : isMe
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey[350],
            ),
            padding: isPhoto
                ? const EdgeInsets.all(0)
                : const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: EdgeInsets.only(
              top: !isPreviousSame ? 50 : 5,
              bottom: 5,
              left: 10,
              right: 10,
            ),
            //make a max width
            constraints: const BoxConstraints(maxWidth: 140),
            // the alignment of the message
            //if the message is photo
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isMe && !isPreviousSame && isGroup)
                  Container(
                    padding: EdgeInsets.all(isPhoto ? 5 : 0),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5),
                          topLeft: Radius.circular(5),
                        ),
                        color: Colors.grey[350]),
                    child: Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                isPhoto
                    ? SizedBox(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topRight: (isPreviousSame || !isMe)
                                ? const Radius.circular(12)
                                : const Radius.circular(0),
                            topLeft: (!isPreviousSame && !isMe)
                                ? const Radius.circular(0)
                                : const Radius.circular(12),
                            bottomRight: const Radius.circular(12),
                            bottomLeft: const Radius.circular(12),
                          ),
                          child: FadeInImage(
                            placeholder:
                                const AssetImage("assets/loading_image.jpg"),
                            image: NetworkImage(
                              message,
                            ),
                          ),
                        ),
                      )
                    // if the message is text
                    : Text(
                        message,
                        style: TextStyle(
                            color: isMe ? Colors.white : Colors.black),
                        textAlign: TextAlign.left,
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
