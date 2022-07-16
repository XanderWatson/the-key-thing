import 'package:flutter/material.dart';
import 'package:the_key_thing/screens/login_screen.dart';
import 'package:the_key_thing/screens/welcome_screen.dart';
import 'package:the_key_thing/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Key Thing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WelcomeScreen(),
      routes: {
        "/home": (_) => const HomeScreen(),
        "/login": (_) => const LoginScreen(),
        "/logout": (_) => const LoginScreen()
      },
    );
  }
}
