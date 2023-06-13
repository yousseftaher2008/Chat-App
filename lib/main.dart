import "package:connectivity_plus/connectivity_plus.dart";
import "package:flutter/material.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";

import "providers/users_providers.dart";
import "screens/group_screen.dart";
import "screens/new_group_screen.dart";
import "screens/no_internet_screen.dart";
import 'screens/onboarding_screens.dart';
import "screens/show_image_screen.dart";
import "screens/chat_screen.dart";
import "screens/profile_screen.dart";
import "screens/auth_screen.dart";
import "screens/chats_screen.dart";

late final bool? isViewed;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  isViewed = pref.getBool("isViewed");
  await Firebase.initializeApp();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});
  bool? _isConnected;

  final Widget loadingScreen = const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
  checkConnection() async {
    var result = await Connectivity().checkConnectivity();
    _isConnected = result.name != "none";
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => UsersProvider(),
      child: MaterialApp(
        title: "Chat App",
        debugShowCheckedModeBanner: false,
        // themeMode: isThemeDark == true ? ThemeMode.dark : ThemeMode.light,
        darkTheme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFF004E8D)),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              minimumSize: MaterialStateProperty.all(const Size(100, 50)),
            ),
          ),
          colorScheme: ColorScheme.fromSwatch(
            primaryColorDark: const Color(0xFF004E8D),
            backgroundColor: Colors.grey,
          ),
        ),
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              minimumSize: MaterialStateProperty.all(const Size(100, 50)),
            ),
          ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
            backgroundColor: Colors.grey,
          ),
        ),
        home: StreamBuilder<ConnectivityResult>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, connection) {
              if (connection.data == ConnectivityResult.none ||
                  _isConnected == false) {
                return const NoInternetScreen();
              }
              return StreamBuilder(
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
                              : AuthScreen()
                          : OnboardingScreen();
                  }
                },
              );
            }),
        routes: {
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          ChatScreen.routeName: (context) => const ChatScreen(),
          NewGroupScreen.routeName: (context) => const NewGroupScreen(),
          ChatsScreen.routeName: (context) => const ChatsScreen(),
          AuthScreen.routeName: (context) => AuthScreen(),
          ShowImageScreen.routeName: (context) => const ShowImageScreen(),
          GroupScreen.routeName: (context) => const GroupScreen(),
          NoInternetScreen.routeName: (context) => const NoInternetScreen(),
        },
      ),
    );
  }
}
