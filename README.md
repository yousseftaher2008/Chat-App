# Chat App

Chat App is a personal training application developed after completing the Flutter & Dart Course. This app allows users to connect with friends, create and manage groups, and have personalized control over their interactions.

## Features

- *Sign in/Sign up:* Secure authentication using Gmail.
- *Friend Search & Connection:* Search for friends and establish connections.
- *Group Creation & Management:* 
  - Create groups.
  - Assign group administrators.
  - Manage users within groups, including removing users and changing admin status.
- *User Blocking:* Block and unblock users for personalized control over interactions.
- *Messaging:* 
  - Send messages to friends.
  - Send emojis in chats.

## Note

The app is currently not available to run as there are some issues with Firebase that need to be resolved. Once these issues are fixed, the app will be shared.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install)
- [Dart](https://dart.dev/get-dart)
- A Firebase account with the necessary setup for authentication and database management.

### Installation

1. *Clone the repository:*
    bash
    git clone https://github.com/yousseftaher2008/chat-app.git
    cd chat-app
    

2. *Install dependencies:*
    bash
    flutter pub get
    

3. *Set up Firebase:*
    - Follow the instructions to add Firebase to your Flutter app [here](https://firebase.google.com/docs/flutter/setup).
    - Make sure to configure Authentication and Firestore Database in your Firebase project.

4. *Run the app:*
    bash
    flutter run
    

## Built With

- [Flutter](https://flutter.dev/) - The UI toolkit used for building natively compiled applications for mobile from a single codebase.
- [Dart](https://dart.dev/) - The programming language used.
- [Firebase](https://firebase.google.com/) - The platform used for backend services such as authentication and database management.

## Acknowledgments

- This app was developed after completing the [Flutter & Dart Course](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/) by Maximilian Schwarzmüller. Thank you, Max, for the excellent course!
