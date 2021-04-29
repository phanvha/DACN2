import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final String title;
  const LoginScreen({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              Text(
                'PORO',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
  }
}