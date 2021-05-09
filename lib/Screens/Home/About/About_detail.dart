import 'package:Poro/Screens/Home/About/Backend/Backend_profile.dart';
import 'package:Poro/Screens/Home/About/Frontend/frontend_profile.dart';
import 'package:Poro/Screens/Home/Home_screen.dart';
import 'package:Poro/Screens/main-screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     home: DefaultTabController(
       length: 2,
       initialIndex: 0,
       child: Scaffold(
         appBar: AppBar(
           backgroundColor: Colors.blue,
           title: const Text("About us", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
           automaticallyImplyLeading: false,
           centerTitle: true,
           actions: [
             IconButton(icon: Icon(Icons.home, color: Colors.black,), onPressed: (){
               Navigator.push(context, MaterialPageRoute(builder: (_) => MainScreen()));
             }),
           ],
           bottom: TabBar(
             labelColor: Colors.black,
             unselectedLabelColor: Colors.grey,
             indicatorSize: TabBarIndicatorSize.label,
             tabs: <Widget>[
               Tab(
                 child: Align(
                   alignment: Alignment.center,
                   child: const Text("Frontend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                 ),
               ),
               Tab(
                 child: Align(
                   alignment: Alignment.center,
                   child: const Text("Backend", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                 ),
               ),
             ],
           ),
         ),
         body: TabBarView(
           children: <Widget>[
              frontendProfile(),
              backendProfile(),
           ],
         ),
       ),
     ),
   );
  }
}