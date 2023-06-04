import 'package:flutter/material.dart';

class ShowImageScreen extends StatelessWidget {
  const ShowImageScreen({super.key});
  static const String routeName = "/show_image_screen";
  @override
  Widget build(BuildContext context) {
    final Map userData = ModalRoute.of(context)!.settings.arguments as Map;
    final String image = userData["image"] as String;
    final String title = userData["title"] as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
