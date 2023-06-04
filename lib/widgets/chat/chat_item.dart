import "package:flutter/material.dart";

class ChatItem extends StatelessWidget {
  const ChatItem(
    this.username,
    this.userImage,
    this.isFriend,
    this.assetImage, {
    this.lastMessage = "",
    this.isAdmin = false,
    this.isBlock = false,
    this.isHeBlock = false,
    super.key,
  });
  final String username;
  final String userImage;
  final String assetImage;
  final bool isFriend;
  final bool isAdmin;
  final bool isBlock;
  final bool isHeBlock;
  final String lastMessage;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(5),
        color: isBlock ? Colors.black12 : Colors.transparent,
        child: ListTile(
          leading: SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage("assets/${assetImage}"),
                image: NetworkImage(userImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: Text(username),
          subtitle: Text(lastMessage),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAdmin)
                const Text(
                  "Admin",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (isBlock)
                const Text(
                  "Blocked",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (!isBlock && isHeBlock)
                const Text("You are Blocked",
                    style: TextStyle(
                      color: Colors.grey,
                    )),
              if (!isFriend && !isBlock && !isHeBlock) const Icon(Icons.add),
            ],
          ),
        ),
      );
}
