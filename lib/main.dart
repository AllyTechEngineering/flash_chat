import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        // debugShowCheckedModeBanner: true,
        theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: Colors.black54),
          ),
        ),
        initialRoute: WelcomeScreen
            .identity, // '/' is the key for the value WelcomeScreen()
        // routes creates a dart map which is key : value pairs. '/' is just a key for the value WelcomeScreen();
        routes: {
          WelcomeScreen.identity: (context) => WelcomeScreen(),
          RegistrationScreen.identity: (context) => RegistrationScreen(),
          LoginScreen.identity: (context) => LoginScreen(),
          ChatScreen.identity: (context) => ChatScreen(),
        });
  }
}