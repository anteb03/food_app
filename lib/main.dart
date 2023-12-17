import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikacija2/help/help.dart';
import 'package:aplikacija2/pages/homepage.dart';
import 'package:aplikacija2/pages/authentification/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = await Helpfunction.getUserLoggedInStatus();
  prefs.setBool('isLoggedIn', isLoggedIn ?? false);
  bool? isEmailVerified = await checkEmailVerified();
  runApp(
      MyApp(isLoggedIn: isLoggedIn ?? false, isEmailVerified: isEmailVerified));
}

Future<bool> checkEmailVerified() async {
  bool isEmailVerified = await checkEmailVerification();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isEmailVerified', isEmailVerified);
  return isEmailVerified;
}

Future<bool> checkEmailVerification() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null && user.emailVerified) {
    return true;
  } else {
    return false;
  }
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final bool isEmailVerified;

  const MyApp(
      {Key? key, required this.isLoggedIn, required this.isEmailVerified})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Rubik'),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? Homepage(isEmailVerified: isEmailVerified)
          : const LoginPage(),
    );
  }
}
