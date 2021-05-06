import 'package:flutter/material.dart';
import 'package:Poro/Components/fluttericon.dart';
import 'package:Poro/Screens/User/Widgets/app_outlinebutton.dart';
import 'package:Poro/Screens/User/Widgets/app_textfield.dart';
import 'package:Poro/constant.dart';


class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/register.jpg",
                    height: 250,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_left),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Text(
              "Sign Up",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Themes.colorHeader,
                fontSize: 32,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppOutlineButton(
                    asset: "assets/images/google.png",
                    ontap: () {},
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: AppOutlineButton(
                    asset: "assets/images/facebook.png",
                    ontap: () {},
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: AppOutlineButton(
                    asset: "assets/images/apple.png",
                    ontap: () {},
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              "Or, register with email...",
              style: TextStyle(color: Colors.black38),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            AppTextField(
              hint: "Email ID",
              icon: FlutterIcons.email,
            ),
            SizedBox(height: 12),
            AppTextField(
              hint: "Password",
              icon: FlutterIcons.lock,
            ),
            SizedBox(height: 12),
            AppTextField(
              hint: "Full Name",
              icon: FlutterIcons.user,
            ),
            SizedBox(height: 24),
            FlatButton(
              color: Themes.colorPrimary,
              padding: EdgeInsets.all(16),
              child: Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}