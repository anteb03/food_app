import 'package:aplikacija2/help/authentification.dart';
import 'package:aplikacija2/help/help.dart';
import 'package:aplikacija2/pages/authentification/loginpage.dart';
import 'package:flutter/material.dart';

class Display3 extends StatefulWidget {
  const Display3({super.key});

  @override
  State<Display3> createState() => _Display3State();
}

class _Display3State extends State<Display3> {
  AuthService authService = AuthService();
  String username = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    await Helpfunction.getUserEmailSf().then((value) {
      setState(() {
        email = value!;
      });
    });
    await Helpfunction.getUserNameSf().then((val) {
      setState(() {
        username = val!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    final paddingCoefficient = screenHeight / 100;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(paddingCoefficient * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: fontSizeCoefficient * 150,
              ),
              SizedBox(height: fontSizeCoefficient),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  username,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSizeCoefficient * 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              SizedBox(height: 60 * fontSizeCoefficient),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10 * fontSizeCoefficient,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.shopping_bag,
                        size: fontSizeCoefficient * 17,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "Orders",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10 * fontSizeCoefficient,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: fontSizeCoefficient * 17,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "User data",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10 * fontSizeCoefficient,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.live_help_rounded,
                        size: fontSizeCoefficient * 17,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "FAQ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10 * fontSizeCoefficient,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.help,
                        size: fontSizeCoefficient * 17,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "Help center",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10 * fontSizeCoefficient,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_user,
                        color: Colors.black,
                        size: fontSizeCoefficient * 17,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "Verify your account.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          title: const Text(
                            "Delete account",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            "If you want to delete account, write us email at example@gmail.com!",
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            IconButton(
                              splashColor: Colors.transparent,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        );
                      });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10 * fontSizeCoefficient,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.black,
                        size: fontSizeCoefficient * 17,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "Delete account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          title: const Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            "Are you sure you want to logout?",
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            IconButton(
                              splashColor: Colors.transparent,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              splashColor: Colors.transparent,
                              onPressed: () async {
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                    (route) => false);
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10 * fontSizeCoefficient,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: Colors.black,
                        size: fontSizeCoefficient * 17,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "LOGOUT",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
