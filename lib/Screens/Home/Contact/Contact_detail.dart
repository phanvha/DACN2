import 'package:Poro/Screens/Home/Contact/List_card.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text(
          "Customer Assistance",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Color(0xFFFAFAFA),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                height: MediaQuery.of(context).size.height - 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[200],
                ),
                child: Column(children: [
                  Expanded(
                    child: GridView.count(
                      crossAxisSpacing: 20,
                      crossAxisCount: 2,
                      childAspectRatio: .94,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        CategoryCard(
                          title: "Frequently asked questions",
                          jsonImage: "assets/images/question1.json",
                          press: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen()));
                          },
                        ),
                        CategoryCard(
                          title: "Customer Care",
                          jsonImage: "assets/images/care.json",
                          press: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
                          },
                        ),
                        CategoryCard(
                          title: "User Feedback",
                          jsonImage: "assets/images/feedback.json",
                          press: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (_) => ContactScreen()));
                          },
                        ),
                        CategoryCard(
                          title: "Chat Online",
                          jsonImage: "assets/images/chat.json",
                          press: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (_) => UploadScreen()));
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