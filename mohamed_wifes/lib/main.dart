import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_screen.dart';

void main() {
  const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mohamed's wife",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CustomScreen(),
    );
  }
}
