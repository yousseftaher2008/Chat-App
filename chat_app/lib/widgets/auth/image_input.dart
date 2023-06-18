import "dart:io";

import "package:chat_app/providers/users_providers.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";

class ImageInput extends StatefulWidget {
  const ImageInput(this.onSelected, {this.assetImage = "user.png", super.key});

  final void Function(File image) onSelected;
  final String assetImage;
  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> takePicture(ImageSource source) async {
    final File? imageFile =
        await Provider.of<UsersProvider>(context, listen: false)
            .takePicture(source);

    if (imageFile != null) {
      setState(() {
        _storedImage = imageFile;
      });
      widget.onSelected(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 100,
        child: Column(
          children: [
            _storedImage != null
                ? CircleAvatar(
                    radius: 30,
                    backgroundImage: FileImage(_storedImage!),
                    backgroundColor: Colors.transparent,
                  )
                : CircleAvatar(
                    radius: 30,
                    child: Image.asset("assets/${widget.assetImage}"),
                    backgroundColor: Colors.transparent,
                  ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.photo_camera),
                    onPressed: () {
                      takePicture(ImageSource.camera);
                    },
                    label: const Text("Camera"),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.image),
                    onPressed: () {
                      takePicture(ImageSource.gallery);
                    },
                    label: const Text("gallery"),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
