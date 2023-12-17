import 'package:aplikacija2/help/authentification.dart';
import 'package:aplikacija2/help/help.dart';
import 'package:aplikacija2/pages/authentification/loginpage.dart';
import 'package:aplikacija2/pages/homepages/userdatacollection.dart';
import 'package:aplikacija2/pages/verification/verification1.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class Display3 extends StatefulWidget {
  const Display3({super.key});

  @override
  State<Display3> createState() => _Display3State();
}

class _Display3State extends State<Display3> {
  AuthService authService = AuthService();
  String username = "";
  String email = "";
  String? _imagePath;
  File? _image;
  bool isEmailVerified = false;
  bool getImage = false;

  @override
  void initState() {
    super.initState();
    getUserData();
    checkIsEmailVerified();
    loadUserProfileImage();
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

  void checkIsEmailVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isVerified = prefs.getBool('isEmailVerified');
    if (isVerified != null && isVerified) {
      setState(() {
        isEmailVerified = true;
      });
    }
    if (!isEmailVerified) {
      checkEmailVerification();
    }
  }

  Future checkEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isEmailVerified', isEmailVerified);
  }

  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _imagePath = image.path;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userProfileImage', _imagePath!);
    }
  }

  Future removeImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userProfileImage');
    setState(() {
      _image = null;
      _imagePath = null;
      getImage = false;
    });
  }

  Future loadUserProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('userProfileImage');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
        _imagePath = imagePath;
        getImage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    final paddingCoefficient = screenHeight / 100;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(paddingCoefficient * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          content: SizedBox(
                            height: fontSizeCoefficient * 55,
                            width: fontSizeCoefficient * 50,
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    pickImage();
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.photo_camera,
                                          color: Colors.white,
                                          size: fontSizeCoefficient * 20),
                                      SizedBox(width: fontSizeCoefficient * 10),
                                      Text(
                                        "UPLOAD NEW IMAGE",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSizeCoefficient * 13),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: fontSizeCoefficient * 7,
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  height: fontSizeCoefficient * 7,
                                ),
                                InkWell(
                                  onTap: () {
                                    removeImage();
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete,
                                          color: Colors.white,
                                          size: fontSizeCoefficient * 20),
                                      SizedBox(width: fontSizeCoefficient * 10),
                                      Text(
                                        "REMOVE CURRENT IMAGE",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSizeCoefficient * 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: _image == null
                    ? Stack(children: [
                        Icon(Icons.account_circle,
                            size: fontSizeCoefficient * 175,
                            color: Colors.grey),
                        Positioned(
                          right: fontSizeCoefficient * 12,
                          bottom: fontSizeCoefficient * 30,
                          child: Icon(
                            Icons.add_a_photo_sharp,
                            size: fontSizeCoefficient * 30,
                            color: Colors.black,
                          ),
                        )
                      ])
                    : ClipOval(
                        child: Image.file(
                          _image!,
                          width: fontSizeCoefficient * 150,
                          height: fontSizeCoefficient * 150,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              if (getImage)
                SizedBox(
                  height: fontSizeCoefficient * 6,
                ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    username,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeCoefficient * 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: fontSizeCoefficient * 1,
                  ),
                  if (isEmailVerified)
                    Icon(Icons.verified,
                        size: fontSizeCoefficient * 15, color: Colors.blue)
                ]),
                SizedBox(
                  height: fontSizeCoefficient * 5,
                ),
                Text(
                  email,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fontSizeCoefficient * 12,
                  ),
                )
              ]),
              SizedBox(height: 45 * fontSizeCoefficient),
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
                        size: fontSizeCoefficient * 15,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "Orders",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 15,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserDataCollection(),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10 * fontSizeCoefficient,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: fontSizeCoefficient * 15,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "User data",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 15,
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
                        size: fontSizeCoefficient * 15,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "FAQ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 15,
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
                        size: fontSizeCoefficient * 15,
                        color: Colors.black,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "Help center",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 15,
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Verification1(),
                      ));
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10 * fontSizeCoefficient,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified_user,
                        color: Colors.black,
                        size: fontSizeCoefficient * 15,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "Verify your account.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 15,
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
                            "If you want to delete account, write us email with user ID in it at example@gmail.com!",
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
                        size: fontSizeCoefficient * 15,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "Delete account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 15,
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
                        size: fontSizeCoefficient * 15,
                      ),
                      SizedBox(width: 10 * fontSizeCoefficient),
                      Text(
                        "LOGOUT",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: fontSizeCoefficient * 15,
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
