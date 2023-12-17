import 'package:flutter/material.dart';
import 'dart:async';

class DisplayGreetings extends StatefulWidget {
  const DisplayGreetings({Key? key}) : super(key: key);

  @override
  DisplayGreetingsState createState() => DisplayGreetingsState();
}

class DisplayGreetingsState extends State<DisplayGreetings> {
  List<String> texts = [
    'Hello, ',
    'Welcome, ',
    'Bonjour, ',
    'Hola, ',
    'Pozdrav, '
  ];
  late String currentText = '';
  late Timer _timer;
  int textIndex = 0;

  @override
  void initState() {
    super.initState();
    currentText = texts[0];
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer(const Duration(seconds: 7), () {
      _deleteCurrentText();
    });
  }

  void _deleteCurrentText() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        if (currentText.isNotEmpty) {
          currentText = currentText.substring(0, currentText.length - 1);
        } else {
          timer.cancel();
          _startTypingNext();
        }
      });
    });
  }

  void _startTypingNext() {
    textIndex = (textIndex + 1) % texts.length;
    final nextText = texts[textIndex];
    int charIndex = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        if (charIndex <= nextText.length) {
          currentText = nextText.substring(0, charIndex);
          charIndex++;
        } else {
          timer.cancel();
          _startTimer();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final fontSizeCoefficient = screenHeight / 700;
    return Center(
      child: Text(
        currentText,
        style: TextStyle(
          color: Colors.black,
          fontSize: fontSizeCoefficient * 22,
        ),
      ),
    );
  }
}
