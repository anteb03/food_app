import 'package:aplikacija2/help/authentification.dart';
import 'package:aplikacija2/help/databaseservice.dart';
import 'package:aplikacija2/help/help.dart';
import 'package:aplikacija2/help/help2.dart';
import 'package:aplikacija2/pages/authentification/registrationpage.dart';
import 'package:aplikacija2/pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  bool isloading = false;
  bool text = true;
  String email = "";
  String password = "";
  late AnimationController _controller;
  final Color _startColor = Colors.blue[300]!;
  final Color _endColor = Colors.blue[600]!;
  Color _buttonColor = Colors.blue[300]!;
  void toggleTextVisibility() {
    setState(() {
      text = !text;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _controller.addListener(() {
      setState(() {
        _buttonColor = Color.lerp(_startColor, _endColor, _controller.value)!;
      });
    });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    final paddingCoefficient = screenHeight / 100;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: isloading
          ? Center(
              child: Lottie.asset(
                'assets/animation_loading.json',
                width: 200 * fontSizeCoefficient,
                height: 200 * fontSizeCoefficient,
              ),
            )
          : Stack(children: [
              Stack(children: [
                Container(
                  height: screenHeight * 0.5,
                  width: double.infinity,
                  color: _buttonColor,
                ),
                Positioned(
                  top: 6 * paddingCoefficient,
                  right: 8 * paddingCoefficient,
                  child: Icon(
                    Icons.circle,
                    size: 60 * fontSizeCoefficient,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  top: 3 * paddingCoefficient,
                  right: 1.5 * paddingCoefficient,
                  child: Icon(
                    Icons.circle,
                    size: 20 * fontSizeCoefficient,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  top: 6 * paddingCoefficient,
                  right: 3 * paddingCoefficient,
                  child: Icon(
                    Icons.circle,
                    size: 10 * fontSizeCoefficient,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                    top: 10 * paddingCoefficient,
                    left: 0.5 * paddingCoefficient,
                    child: Icon(
                      Icons.circle,
                      size: 200 * fontSizeCoefficient,
                      color: Colors.white,
                    )),
                Positioned(
                    top: 10 * paddingCoefficient,
                    left: 5 * paddingCoefficient,
                    child: Icon(
                      Icons.circle,
                      color: Colors.grey,
                      size: 50 * fontSizeCoefficient,
                    )),
                Positioned(
                    top: 25 * paddingCoefficient,
                    right: 1 * paddingCoefficient,
                    child: Icon(
                      Icons.circle,
                      color: Colors.grey,
                      size: 100 * fontSizeCoefficient,
                    )),
              ]),
              Positioned(
                top: screenHeight * 0.55,
                left: 0.5 * paddingCoefficient,
                child: Icon(
                  Icons.circle,
                  size: 100 * fontSizeCoefficient,
                  color: Colors.grey,
                ),
              ),
              Positioned(
                top: screenHeight * 0.8,
                left: 1.5 * paddingCoefficient,
                child: Icon(
                  Icons.circle,
                  size: 70 * fontSizeCoefficient,
                  color: _buttonColor,
                ),
              ),
              Positioned(
                top: screenHeight * 0.9,
                left: 10 * paddingCoefficient,
                child: Icon(
                  Icons.circle,
                  size: 200 * fontSizeCoefficient,
                  color: Colors.grey,
                ),
              ),
              Positioned(
                top: screenHeight * 0.65,
                right: 0.2 * paddingCoefficient,
                child: Icon(
                  Icons.circle,
                  size: 150 * fontSizeCoefficient,
                  color: _buttonColor,
                ),
              ),
              Positioned(
                  top: screenHeight * 0.85,
                  left: 9 * paddingCoefficient,
                  child: Icon(
                    Icons.circle,
                    size: 20 * fontSizeCoefficient,
                    color: Colors.grey,
                  )),
              Positioned(
                  top: screenHeight * 0.85,
                  left: 15 * paddingCoefficient,
                  child: Icon(
                    Icons.circle,
                    size: 40 * fontSizeCoefficient,
                    color: Colors.grey,
                  )),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final paddingValue = paddingCoefficient * 1.5;
                  final formWidth = MediaQuery.of(context).size.width * 0.8;
                  return Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(paddingValue * 0.5),
                        child: Container(
                          width: formWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[350],
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(paddingValue * 1.5),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 15 * fontSizeCoefficient),
                                  Text(
                                    "FOOD STORE",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 25 * fontSizeCoefficient,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 25 * fontSizeCoefficient),
                                  Text(
                                    "Login to see what we can offer you!",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13 * fontSizeCoefficient,
                                    ),
                                  ),
                                  SizedBox(height: 22 * fontSizeCoefficient),
                                  TextFormField(
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13 * fontSizeCoefficient,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        email = value;
                                      });
                                    },
                                    validator: (value) {
                                      return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                                      ).hasMatch(value!)
                                          ? null
                                          : "Please enter a valid email";
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Email",
                                      labelStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13 * fontSizeCoefficient,
                                      ),
                                      prefixIcon: const Icon(Icons.email,
                                          color: Colors.black),
                                      fillColor: Colors.black12,
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 15 * fontSizeCoefficient,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16 * fontSizeCoefficient),
                                  TextFormField(
                                    cursorColor: Colors.black,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13 * fontSizeCoefficient,
                                    ),
                                    obscureText: text,
                                    onChanged: (value) {
                                      setState(() {
                                        password = value;
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.length < 6) {
                                        return "Password must contain at least 6 characters";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      labelStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13 * fontSizeCoefficient,
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: toggleTextVisibility,
                                        child: Icon(
                                          text
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black,
                                        ),
                                      ),
                                      prefixIcon: const Icon(Icons.key,
                                          color: Colors.black),
                                      fillColor: Colors.black12,
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 15 * fontSizeCoefficient,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.zero,
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.zero,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20 * fontSizeCoefficient),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Don't have an account?",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12 * fontSizeCoefficient,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 7 * fontSizeCoefficient,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegistrationPage(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Register now.",
                                          style: TextStyle(
                                            color: Colors.blue[500],
                                            fontSize: 12 * fontSizeCoefficient,
                                            decoration: TextDecoration.combine(
                                              [TextDecoration.underline],
                                            ),
                                            decorationColor: Colors.blue,
                                            decorationThickness: 1,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 25 * fontSizeCoefficient),
                                  SizedBox(
                                    width: 200 * fontSizeCoefficient,
                                    height: 50 * fontSizeCoefficient,
                                    child: TweenAnimationBuilder(
                                      tween: Tween(begin: 0.0, end: 0.5),
                                      duration:
                                          const Duration(milliseconds: 50),
                                      builder: (context, value, child) {
                                        return ElevatedButton(
                                          onPressed: () {
                                            loginfun();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: _buttonColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  2 * fontSizeCoefficient),
                                              child: Text(
                                                "SIGN IN",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      16 * fontSizeCoefficient,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 15 * fontSizeCoefficient),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ]),
    );
  }

  loginfun() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      await authService.loginUserWithEmail(email, password).then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          await Helpfunction.saveUserLoggedInStatus(true);
          await Helpfunction.saveUserEmailSF(email);
          await Helpfunction.saveUserNameSF(snapshot.docs[0]["fullName"]);
          screenReplace(context, const Homepage());
        } else {
          snackbar(context, Colors.red, value);
          setState(() {
            isloading = false;
          });
        }
      });
    }
  }
}
