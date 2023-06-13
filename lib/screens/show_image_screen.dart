import 'package:flutter/material.dart';

class ShowImageScreen extends StatelessWidget {
  const ShowImageScreen({super.key});
  static const String routeName = "/show_image_screen";
  @override
  Widget build(BuildContext context) {
    final Map userData = ModalRoute.of(context)!.settings.arguments as Map;
    final String image = userData["image"] as String;
    final String id = userData["id"] as String;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Hero(
        tag: id,
        child: Center(
          child: Container(
            width: double.infinity,
            child: Image.network(
              image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
