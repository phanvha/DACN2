import 'package:Poro/Screens/Home/Home_screen.dart';
import 'package:Poro/Screens/User/Login_screen.dart';
import 'package:Poro/Screens/User/Signup_screen.dart';
import 'package:Poro/Screens/main-screen.dart';
import 'package:Poro/constant.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/services.dart';

class WelcomeScreen extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                      "Welcome",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                      "Welcome to the driver's bumping point bad road warning system",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/welcome.png'),
                  )
                ),
              ),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blue
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
                      },
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(
                      "Continue without an account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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