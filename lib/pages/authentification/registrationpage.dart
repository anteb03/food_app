import 'package:aplikacija2/help/authentification.dart';
import 'package:aplikacija2/help/help2.dart';
import 'package:aplikacija2/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:aplikacija2/help/help.dart';
import 'package:lottie/lottie.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage>
    with SingleTickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();
  bool isloading = false;
  bool text = true;
  bool ischeckedbox = false;
  String email = "";
  String password = "";
  String fullname = "";
  late AnimationController _controller;
  final Color _startColor = Colors.blue[300]!;
  final Color _endColor = Colors.blue[600]!;
  Color _buttonColor = Colors.blue[300]!;
  AuthService authService = AuthService();

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
      backgroundColor: Colors.white70,
      resizeToAvoidBottomInset: false,
      body: isloading
          ? Center(
              child: Lottie.asset(
                'assets/animation_loading.json',
                width: 300 * fontSizeCoefficient,
                height: 300 * fontSizeCoefficient,
              ),
            )
          : LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
              final paddingvalue = paddingCoefficient * 2;
              return Center(
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(paddingvalue * 2),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Register to access the app!",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: fontSizeCoefficient * 14),
                            ),
                            SizedBox(height: fontSizeCoefficient * 25),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              onChanged: (value) {
                                setState(() {
                                  fullname = value;
                                });
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Field cannot be empty.';
                                } else if (value[0] != value[0].toUpperCase()) {
                                  return 'Name must be with first letter uppercase.';
                                } else if (!RegExp(r'^[A-Za-z]*$')
                                    .hasMatch(value.substring(1))) {
                                  return 'Field must only contain letters.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: "Name",
                                  labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: fontSizeCoefficient * 13),
                                  prefixIcon: const Icon(Icons.abc,
                                      color: Colors.black87),
                                  fillColor: Colors.black12,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15 * fontSizeCoefficient),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 15.0,
                                      ),
                                      borderRadius: BorderRadius.zero),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.zero,
                                  )),
                            ),
                            SizedBox(height: fontSizeCoefficient * 16),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                              validator: (value) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value!)
                                    ? null
                                    : "Please enter valid email";
                              },
                              decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle: TextStyle(
                                      color: Colors.black87,
                                      fontSize: fontSizeCoefficient * 13),
                                  prefixIcon: const Icon(Icons.email,
                                      color: Colors.black87),
                                  fillColor: Colors.black12,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15 * fontSizeCoefficient),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 15.0,
                                      ),
                                      borderRadius: BorderRadius.zero),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.zero,
                                  )),
                            ),
                            SizedBox(height: 16 * fontSizeCoefficient),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              cursorColor: Colors.black,
                              obscureText: text ? true : false,
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
                                      color: Colors.black87,
                                      fontSize: fontSizeCoefficient * 13),
                                  suffixIcon: GestureDetector(
                                    onTap: toggleTextVisibility,
                                    child: Icon(
                                      text
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.key,
                                      color: Colors.black87),
                                  fillColor: Colors.black12,
                                  filled: true,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15 * fontSizeCoefficient),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 15.0,
                                      ),
                                      borderRadius: BorderRadius.zero),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.zero,
                                  )),
                            ),
                            SizedBox(height: 16 * fontSizeCoefficient),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.all<Color>(
                                        Colors.black),
                                    side: const BorderSide(
                                      color: Colors.black,
                                    ),
                                    value: ischeckedbox,
                                    onChanged: (value) {
                                      setState(() {
                                        ischeckedbox = value!;
                                      });
                                    }),
                                Text(
                                  "You accept the privacy policy and terms of use.",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: fontSizeCoefficient * 10),
                                )
                              ],
                            ),
                            SizedBox(height: 16 * fontSizeCoefficient),
                            SizedBox(
                              width: 200 * fontSizeCoefficient,
                              height: 50 * fontSizeCoefficient,
                              child: TweenAnimationBuilder(
                                tween: Tween(begin: 0.0, end: 0.5),
                                duration: const Duration(milliseconds: 50),
                                builder: (context, value, child) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      if (ischeckedbox) {
                                        reginfun();
                                      } else {
                                        snackbar(context, Colors.red,
                                            "You must accept privacy policy and terms.");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _buttonColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
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
                                            fontSize: 16 * fontSizeCoefficient,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
    );
  }

  reginfun() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isloading = true;
      });
      await authService
          .registerUserWithEmailAndPassword(fullname, email, password)
          .then((value) async {
        if (value == true) {
          await Helpfunction.saveUserLoggedInStatus(true);
          await Helpfunction.saveUserEmailSF(email);
          await Helpfunction.saveUserNameSF(fullname);
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
