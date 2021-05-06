import 'package:Poro/Screens/Home/About/About_detail.dart';
import 'package:Poro/Screens/Home/Contact/Contact_detail.dart';
import 'package:Poro/Screens/Home/Map/Map_detail.dart';
import 'package:Poro/Screens/Home/Upload/Upload_detail.dart';
import 'package:Poro/Screens/Home/Widgets/CardView.dart';
import 'package:Poro/Screens/Home/Widgets/category_card.dart';
import 'package:Poro/Screens/SideBar/Sidebar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class homeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF80D8FF),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('DaNang, VietNam', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
            Icon(Icons.arrow_drop_down_sharp),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.menu_open_outlined),
          onPressed: () {
          },
        ),
        actions: [
          IconButton(
              icon: Image.asset("assets/images/bell.png", width: 25),
              onPressed: () {
                return Container(
                  child: Scaffold(
                    drawer: MainDrawer(),
                  ),
                );
              },
          ),
        ],
      ),
      body: ListView(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFF80D8FF),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(right: 60),
                      child: Column(
                        children: [
                          Lottie.asset("assets/images/banner.json", height: 190, width: 190),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Expanded(
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              //     height: MediaQuery.of(context).size.height - 200,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(30),
              //       color: Colors.grey[200],
              //     ),
              //     child: Column(children: [
              //       mainCard(context),
              //       SizedBox(height: 20),
              //       Expanded(
              //         child: GridView.count(
              //           crossAxisSpacing: 20,
              //           crossAxisCount: 2,
              //           childAspectRatio: .94,
              //           mainAxisSpacing: 10,
              //           children: <Widget>[
              //             CategoryCard(
              //               title: "Map",
              //               jsonImage: "assets/images/map1.json",
              //               press: () {},
              //             ),
              //             CategoryCard(
              //               title: "About",
              //               jsonImage: "assets/images/about.json",
              //               press: () {},
              //             ),
              //             CategoryCard(
              //               title: "Contact",
              //               jsonImage: "assets/images/contact.json",
              //               press: () {},
              //             ),
              //             CategoryCard(
              //               title: "Upload data",
              //               jsonImage: "assets/images/upload.json",
              //               press: () {},
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                height: MediaQuery.of(context).size.height - 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[200],
                ),
                child: Column(children: [
                  mainCard(context),
                  SizedBox(height: 40),
                  Expanded(
                    child: GridView.count(
                      crossAxisSpacing: 20,
                      crossAxisCount: 2,
                      childAspectRatio: .94,
                      mainAxisSpacing: 10,
                      children: <Widget>[
                        CategoryCard(
                          title: "Map",
                          jsonImage: "assets/images/map1.json",
                          press: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen()));
                          },
                        ),
                        CategoryCard(
                          title: "About",
                          jsonImage: "assets/images/about.json",
                          press: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
                          },
                        ),
                        CategoryCard(
                          title: "Assistances",
                          jsonImage: "assets/images/contact.json",
                          press: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => ContactScreen()));
                          },
                        ),
                        CategoryCard(
                          title: "Upload data",
                          jsonImage: "assets/images/upload.json",
                          press: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => UploadScreen()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],),
              ),
            ],
          ),
        ),
      ],),
    );
  }
}