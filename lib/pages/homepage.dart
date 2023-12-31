import 'package:aplikacija2/pages/homepages/display1.dart';
import 'package:aplikacija2/pages/homepages/display2.dart';
import 'package:aplikacija2/pages/homepages/display3.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  final bool? isEmailVerified;
  const Homepage({Key? key, this.isEmailVerified}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late List<Widget> screens;
  late AnimationController _controller;
  final Color _startColor = Colors.blue[300]!;
  final Color _endColor = Colors.blue[600]!;
  Color bottomcnavcolor = Colors.blue[300]!;

  var _pageController = PageController();

  @override
  void initState() {
    super.initState();
    screens = [
      Display1(
        isEmailVerified: widget.isEmailVerified,
      ),
      const Display2(),
      const Display3(),
    ];
    _pageController = PageController(initialPage: _selectedIndex);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _controller.addListener(() {
      setState(() {
        bottomcnavcolor =
            Color.lerp(_startColor, _endColor, _controller.value)!;
      });
    });

    _controller.repeat(reverse: true);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    });
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
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          if (notification is ScrollEndNotification) {
            setState(() {
              _selectedIndex = _pageController.page?.round() ?? 0;
            });
          }
          return true;
        },
        child: PageView(
          controller: _pageController,
          children: screens,
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60 * fontSizeCoefficient,
        child: Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: paddingCoefficient * 1.7,
                left: paddingCoefficient * 6,
                right: paddingCoefficient * 6),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(50), bottom: Radius.circular(50)),
              child: BottomNavigationBar(
                showSelectedLabels: true,
                showUnselectedLabels: false,
                currentIndex: _selectedIndex,
                backgroundColor: bottomcnavcolor,
                unselectedItemColor: Colors.black54,
                selectedItemColor: Colors.black,
                selectedLabelStyle:
                    TextStyle(fontSize: fontSizeCoefficient * 12),
                onTap: _onItemTapped,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.shop,
                      size: fontSizeCoefficient * 20,
                    ),
                    label: 'Offer',
                  ),
                  BottomNavigationBarItem(
                    icon:
                        Icon(Icons.headset_mic, size: fontSizeCoefficient * 20),
                    label: 'Live Support',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle,
                        size: fontSizeCoefficient * 20),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
