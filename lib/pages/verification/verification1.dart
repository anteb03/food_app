import 'dart:async';
import 'package:aplikacija2/help/help.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Verification1 extends StatefulWidget {
  const Verification1({super.key});

  @override
  State<Verification1> createState() => _Verification1State();
}

class _Verification1State extends State<Verification1> {
  bool isEmailVerified = false;
  User? currentUser;
  String email = "";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    getUserData();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationCode();
      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerification(),
      );
    }
  }

  getUserData() async {
    await Helpfunction.getUserEmailSf().then((value) {
      setState(() {
        email = value!;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationCode() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    final paddingCoefficient = screenHeight / 100;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isEmailVerified ? Colors.black : Colors.white,
        leading: InkWell(
          child: isEmailVerified
              ? Icon(
                  Icons.arrow_back,
                  size: fontSizeCoefficient * 25,
                  color: Colors.white,
                )
              : Icon(
                  Icons.arrow_back,
                  size: fontSizeCoefficient * 25,
                  color: Colors.black,
                ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: isEmailVerified
          ? Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: fontSizeCoefficient * 40,
                    ),
                    SizedBox(
                      height: fontSizeCoefficient * 5,
                    ),
                    Text(
                      "Your email is verified.",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSizeCoefficient * 15),
                    ),
                    Text(
                      "You can order food now!",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSizeCoefficient * 15),
                    ),
                  ],
                ),
              ),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              body: Stack(
                children: [
                  Stack(
                    children: [
                      Positioned(
                        top: paddingCoefficient * 0.05,
                        left: paddingCoefficient * 15,
                        child: Icon(
                          Icons.circle,
                          size: fontSizeCoefficient * 200,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Positioned(
                        top: paddingCoefficient * 7,
                        right: 17 * paddingCoefficient,
                        child: Icon(
                          Icons.circle,
                          size: fontSizeCoefficient * 200,
                          color: Colors.blue,
                        ),
                      ),
                      Positioned(
                        top: paddingCoefficient * 70,
                        left: 25 * paddingCoefficient,
                        child: Icon(
                          Icons.circle,
                          size: fontSizeCoefficient * 300,
                          color: Colors.lightBlue,
                        ),
                      ),
                      Positioned(
                        top: paddingCoefficient * 70,
                        right: 40 * paddingCoefficient,
                        child: Icon(
                          Icons.circle,
                          size: fontSizeCoefficient * 150,
                          color: Colors.lightBlue,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(paddingCoefficient * 2),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              "We send link to your email",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: fontSizeCoefficient * 15),
                            ),
                          ),
                          Center(
                            child: Text(email,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: fontSizeCoefficient * 15,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Center(
                            child: Text(
                              "Enter the link to verify!",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: fontSizeCoefficient * 15),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
