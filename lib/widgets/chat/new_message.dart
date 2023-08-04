import "dart:io";

import "package:chat_app/providers/users_providers.dart";
import "package:emoji_picker_flutter/emoji_picker_flutter.dart";
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

  final FocusNode _focusNode = FocusNode();
  bool _isShowEmoji = false;
  bool _isLoading = false;
  bool _isShowSendButton = false;
  Future<void> _sendMessage(
      [String type = "text", String? url, String? messageId]) async {
    FocusScope.of(context).unfocus();
    if (!_isLoading && type == "photo") {
      return;
    }

    try {
      final bool isPhoto = type == "photo";
      final message = _controller.text;
      _controller.clear();
      _enteredMessage = "";
      _isShowSendButton = false;
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
      final String id = usersProvider.generateChatId();
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
            : Column(
                children: [
                  Row(children: [
                    Expanded(
                      child: TextField(
                        focusNode: _focusNode,
                        controller: _controller,
                        autocorrect: true,
                        textCapitalization: TextCapitalization.sentences,
                        enableSuggestions: true,
                        onTap: () {
                          setState(() {
                            _isShowEmoji = false;
                          });
                        },
                        decoration: InputDecoration(
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: _enteredMessage.trim().isEmpty &&
                                        !_isLoading
                                    ? () => _sendPhoto(ImageSource.gallery)
                                    : null,
                                icon: const Icon(Icons.photo),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              IconButton(
                                onPressed: _enteredMessage.trim().isEmpty &&
                                        !_isLoading
                                    ? () => _sendPhoto(ImageSource.camera)
                                    : null,
                                icon: const Icon(Icons.photo_camera),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.emoji_emotions_outlined),
                            onPressed: () {
                              _isShowEmoji
                                  ? _focusNode.requestFocus()
                                  : _focusNode.unfocus();
                              setState(() {
                                _isShowEmoji = !_isShowEmoji;
                              });
                            },
                          ),
                          hintText: "send Message",
                        ),
                        onChanged: (value) {
                          _enteredMessage = value;
                          if (value.trim() != "" && !_isShowSendButton) {
                            setState(() {
                              _isShowSendButton = true;
                            });
                          } else if (value.trim() == "") {
                            setState(() {
                              _isShowSendButton = false;
                            });
                          }
                        },
                        onSubmitted: _isShowSendButton ? _sendMessage : null,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _isShowSendButton ? _sendMessage : null,
                    )
                  ]),
                  if (_isShowEmoji)
                    SizedBox(
                      height: 200,
                      child: EmojiPicker(
                        onEmojiSelected: (category, emoji) {
                          _controller.text += emoji.emoji;
                          if (!_isShowSendButton) {
                            setState(() {
                              _isShowSendButton = true;
                            });
                          }
                        },
                      ),
                    )
                ],
              ),
      );
}
