import 'package:Poro/Screens/Home/About/Frontend/utils/number_widget_frontend.dart';
import 'package:Poro/Screens/Home/About/Frontend/utils/user_preferences.dart';
import 'package:Poro/Screens/Home/About/model/user.dart';
import 'package:Poro/Screens/Home/About/widget/appbar_widget.dart';
import 'package:Poro/Screens/Home/About/widget/button_widget.dart';
import 'package:Poro/Screens/Home/About/widget/numbers_widget.dart';
import 'package:Poro/Screens/Home/About/widget/profile_widget.dart';
import 'package:flutter/material.dart';

class frontendProfile extends StatefulWidget {
  @override
  _ProfileFrontedState createState() => _ProfileFrontedState();
// TODO: implement createState
}
class _ProfileFrontedState extends State<frontendProfile> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final user  = UserPreferences.myUser;
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),
          Center(child: buildUpgradeButton()),
          const SizedBox(height: 24),
          NumbersWidgetFrontend(),
          const SizedBox(height: 48),
          buildAbout(user),
        ],
      ),
    );
  }
  Widget buildName(User user) => Column(
    children: [
      Text(
        user.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(
        user.email,
        style: TextStyle(color: Colors.grey),
      )
    ],
  );
  Widget buildUpgradeButton() => ButtonWidget(
    text: 'Watch All',
    onClicked: () {},
  );
  Widget buildAbout(User user) => Container(
    padding: EdgeInsets.symmetric(horizontal: 48),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          user.about,
          style: TextStyle(fontSize: 16, height: 1.4),
        ),
      ],
    ),
  );
}