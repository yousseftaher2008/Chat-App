import "package:chat_app/screens/auth_screen.dart";
import "package:flutter/material.dart";
import "package:introduction_screen/introduction_screen.dart";
import "package:shared_preferences/shared_preferences.dart";

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final List<PageViewModel> pageViewList = [
    PageViewModel(
      title: "Chat App",
      body:
          "the best app to chat over the world Which was made by Youssef Taher  ",
      image: const Center(
        child: CircleAvatar(
          backgroundImage: AssetImage("assets/chat_app_logo.jpg"),
          radius: 100,
        ),
      ),
    ),
    PageViewModel(
      title: "Advantages",
      body:
          "We give you possibilities to talk to anyone from anywhere anytime for free",
      image: const Center(
        child: CircleAvatar(
          backgroundImage: AssetImage("assets/chating.jpg"),
          radius: 100,
        ),
      ),
    ),
    PageViewModel(
      title: "Privacy",
      body:
          "We give you high privacy as no one can talk to you without your permission and you can block any one.",
      image: const Center(
        child: CircleAvatar(
          backgroundImage: AssetImage("assets/privacy.jpg"),
          radius: 100,
        ),
      ),
    ),
  ];

  Future<void> storeIsViewed() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("isViewed", true);
  }

  @override
  Widget build(BuildContext context) => IntroductionScreen(
        pages: pageViewList,
        showSkipButton: true,
        showNextButton: true,
        skip: const Text("Skip"),
        next: const Text("Next"),
        done: const Text("Done"),
        onSkip: () async {
          await storeIsViewed();

          await Navigator.of(context)
              .pushReplacementNamed(AuthScreen.routeName);
        },
        onDone: () async {
          await storeIsViewed();

          await Navigator.of(context)
              .pushReplacementNamed(AuthScreen.routeName);
        },
      );
}
