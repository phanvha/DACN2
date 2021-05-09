import 'package:Poro/Components/fluttericon.dart';
import 'package:Poro/Screens/Home/Home_screen.dart';
import 'package:Poro/Screens/User/Widgets/app_outlinebutton.dart';
import 'package:Poro/Screens/User/Widgets/app_textfield.dart';
import 'package:Poro/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:Poro/Screens/User/Signup_screen.dart';

import '../main-screen.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
    // TODO: implement createState
}

class _LoginScreenState extends State<LoginScreen> {
  TapGestureRecognizer registerOnTap;
  @override
  void initState() {
    // TODO: implement initState
    registerOnTap = TapGestureRecognizer();
    registerOnTap..onTap = () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => SignupScreen(),
          ),
      );
    };
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            Image.asset("assets/images/login.jpg", height: 250,),
            Text(
              "Login",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Themes.colorHeader,
                fontSize: 32,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            AppTextField(
                icon: FlutterIcons.email,
                hint: "Email ID",
            ),
            SizedBox(height: 12),
            AppTextField(
                icon: FlutterIcons.lock,
                hint: "Password",
              helpContent: Text(
                "Forgot ?",
                style: TextStyle(fontSize: 16, color: Themes.colorPrimary),
              ),
              helpOnTap: () {},
            ),
            SizedBox(height: 12),
            FlatButton(
                color: Themes.colorPrimary,
                padding: EdgeInsets.all(16),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainScreen()));
              },
            ),
            SizedBox(height: 24),
            Text(
              "Or, login with...",
              style: TextStyle(
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppOutlineButton(
                    asset: "assets/images/google.png",
                    ontap: () {},
                  ),
                ),
                SizedBox(height: 12),
                Expanded(
                    child: AppOutlineButton(
                      asset: "assets/images/facebook.png",
                      ontap: () {},
                    ),
                ),
                SizedBox(height: 12),
                Expanded(
                    child: AppOutlineButton(
                      asset: "assets/images/apple.png",
                      ontap: () {},
                    ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text.rich(
              TextSpan(
                text: "Do not have an account ?",
                children: [
                  TextSpan(
                    text: "Register",
                    style: TextStyle(
                      color: Themes.colorPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: registerOnTap,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}