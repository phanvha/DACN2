import 'package:Poro/Screens/Home/Home_screen.dart';
import 'package:Poro/Screens/Profile/profile-screen.dart';
import 'package:Poro/Screens/Start/discover-screen.dart';
import 'package:Poro/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  MainScreen() : super();
  @override
  _mainScreen createState() => _mainScreen();
}

class _mainScreen extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color _color1, _color2;
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    DiscoverScreen(),
    ProfileScreen()
  ];
  PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped, // new
          currentIndex: _currentIndex, // new
          unselectedFontSize: 9,
          selectedFontSize: 12,
          elevation: 15,
          selectedItemColor: kPrimaryColor,
          type: BottomNavigationBarType.fixed,
          items: [
            new BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              title: Text('Home',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ),
            new BottomNavigationBarItem(
              icon: Icon(Icons.assistant_direction),
              title: Text(
                'Discover',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            new BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded),
                title: Text('Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )))
          ],
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[_children[_currentIndex]],
        ));

  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      // _pageController.animateToPage(index,
      //     duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    });
  }
}
