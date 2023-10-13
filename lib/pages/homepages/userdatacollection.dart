import 'package:aplikacija2/help/databaseservice.dart';
import 'package:aplikacija2/help/help.dart';
import 'package:aplikacija2/pages/verification/verification1.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aplikacija2/help/authentification.dart';
import 'package:flutter/services.dart';

class UserDataCollection extends StatefulWidget {
  const UserDataCollection({super.key});

  @override
  State<UserDataCollection> createState() => _UserDataCollectionState();
}

class _UserDataCollectionState extends State<UserDataCollection> {
  AuthService authService = AuthService();
  String username = "";
  String email = "";
  String uid = "";
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    getUserData();
    getUidFromDatabaseService();
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      isVerified = user.emailVerified;
    }
  }

  void getUidFromDatabaseService() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String currentUid = user.uid;
      DatabaseService databaseService = DatabaseService(currentUid);
      uid = currentUid;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    final paddingCoefficient = screenHeight / 100;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(paddingCoefficient * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "User data:",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSizeCoefficient * 13,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: fontSizeCoefficient * 12,
              ),
              Row(
                children: [
                  Icon(
                    Icons.abc,
                    size: fontSizeCoefficient * 20,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: fontSizeCoefficient * 6,
                  ),
                  Text(
                    username,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeCoefficient * 13,
                    ),
                  ),
                  SizedBox(
                    width: fontSizeCoefficient * 6,
                  ),
                  if (isVerified)
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: fontSizeCoefficient * 13,
                    ),
                ],
              ),
              SizedBox(
                height: fontSizeCoefficient * 12,
              ),
              Row(
                children: [
                  Icon(
                    Icons.email,
                    size: fontSizeCoefficient * 16,
                    color: isVerified ? Colors.black : Colors.red,
                  ),
                  SizedBox(
                    width: fontSizeCoefficient * 10,
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      color: isVerified ? Colors.black : Colors.red,
                      fontSize: fontSizeCoefficient * 13,
                    ),
                  ),
                  SizedBox(
                    width: fontSizeCoefficient * 10,
                  ),
                  if (isVerified)
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: fontSizeCoefficient * 13,
                    )
                  else
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Verification1(),
                          ),
                        );
                      },
                      child: Text("Verify!",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: fontSizeCoefficient * 12,
                              decoration: TextDecoration.underline)),
                    )
                ],
              ),
              SizedBox(
                height: fontSizeCoefficient * 12,
              ),
              Row(
                children: [
                  Text(
                    "#",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeCoefficient * 20,
                    ),
                  ),
                  SizedBox(
                    width: fontSizeCoefficient * 10,
                  ),
                  Text(
                    uid,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeCoefficient * 11,
                    ),
                  ),
                  SizedBox(
                    width: fontSizeCoefficient * 10,
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: uid));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('UserID is coppied to clipboard'),
                        duration: Duration(seconds: 2),
                      ));
                    },
                    child: Icon(
                      Icons.copy,
                      size: fontSizeCoefficient * 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
