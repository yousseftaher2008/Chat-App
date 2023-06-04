import "dart:io";
import "dart:math";

import "package:chat_app/providers/users_providers.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";

class NewMessage extends StatefulWidget {
  const NewMessage(this.chatId, {super.key});
  final String chatId;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String _enteredMessage = "";
  final _controller = TextEditingController();
  bool _isLoading = false;
  Future<void> _sendMessage(
      [String type = "text", String? url, String? messageId]) async {
    FocusScope.of(context).unfocus();
    if ((_enteredMessage == "" || _controller.text == "") && !_isLoading) {
      return;
    }

    try {
      final bool isPhoto = type == "photo";
      final message = _enteredMessage.trim();
      _controller.clear();
      _enteredMessage = "";
      final UsersProvider usersProvider =
          Provider.of<UsersProvider>(context, listen: false);

      if (isPhoto) {
        await usersProvider.addMessage(
            url!, widget.chatId, type, isPhoto, messageId);
      } else {
        await usersProvider.addMessage(message, widget.chatId, type);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Can't send message, Please check you InterNet"),
        ),
      );
    }
  }

  Future<void> _sendPhoto(ImageSource source) async {
    setState(() {
      _isLoading = true;
    });
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final File? image = await usersProvider.takePicture(
      source,
    );
    if (image != null) {
      const _chars =
          "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
      Random _rnd = Random();

      String getRandomString(int length) =>
          String.fromCharCodes(Iterable.generate(
              length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

      final String id = getRandomString(20);
      final url = await usersProvider.sendFile(image, id);
      await _sendMessage("photo", url, id);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(8),
        child: _isLoading
            ? const SizedBox(
                height: 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 10),
                    Text("Reload the photo...")
                  ],
                ),
              )
            : Row(children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    autocorrect: true,
                    textCapitalization: TextCapitalization.sentences,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed:
                                _enteredMessage.trim().isEmpty && !_isLoading
                                    ? () => _sendPhoto(ImageSource.gallery)
                                    : null,
                            icon: const Icon(Icons.photo),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          IconButton(
                            onPressed:
                                _enteredMessage.trim().isEmpty && !_isLoading
                                    ? () => _sendPhoto(ImageSource.camera)
                                    : null,
                            icon: const Icon(Icons.photo_camera),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                      hintText: "send Message",
                    ),
                    onChanged: (value) {
                      setState(() {
                        _enteredMessage = value;
                      });
                    },
                    onSubmitted: (_) {
                      _enteredMessage.trim().isEmpty ? null : _sendMessage();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed:
                      _enteredMessage.trim().isEmpty ? null : _sendMessage,
                )
              ]),
      );
}
