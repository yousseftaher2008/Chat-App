import "package:chat_app/screens/group_screen.dart";
import "package:chat_app/screens/new_group_screen.dart";
import 'package:chat_app/screens/onboarding_screens.dart';
import "package:chat_app/screens/show_image_screen.dart";
import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

import "providers/users_providers.dart";
import "screens/chat_screen.dart";
import "screens/profile_screen.dart";
import "screens/auth_screen.dart";
import "screens/chats_screen.dart";
import "screens/search_screen.dart";

late final bool? isViewed;
void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  isViewed = pref.getBool("isViewed");
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final Widget loadingScreen = const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (ctx) => UsersProvider(),
        child: MaterialApp(
          title: "Chat App",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (_, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return loadingScreen;
                case ConnectionState.done:
                case ConnectionState.active:
                  return isViewed == true
                      ? snapshot.hasData
                          ? const ChatsScreen()
                          : const AuthScreen()
                      : OnboardingScreen(snapshot.hasData);
              }
            },
          ),
          routes: {
            ProfileScreen.routeName: (context) => const ProfileScreen(),
            ChatScreen.routeName: (context) => const ChatScreen(),
            SearchScreen.routeName: (context) => const SearchScreen(),
            ChatsScreen.routeName: (context) => const ChatsScreen(),
            AuthScreen.routeName: (context) => const AuthScreen(),
            ShowImageScreen.routeName: (context) => const ShowImageScreen(),
            GroupScreen.routeName: (context) => const GroupScreen(),
            NewGroupScreen.routeName: (context) => const NewGroupScreen(),
          },
        ),
      );
}
