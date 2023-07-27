import 'package:aplikacija2/help/help.dart';
import 'package:aplikacija2/pages/homepage.dart';
import 'package:aplikacija2/pages/authentification/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool issigned = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await Helpfunction.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          issigned = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Rubik'),
      debugShowCheckedModeBanner: false,
      home: issigned ? const Homepage() : const LoginPage(),
    );
  }
}
