import 'dart:io';
import 'package:Poro/Model/DatabaseModel/UserHive.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';



class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  void setData() async{
    var path = Directory.current.path;
    var box = await Hive.openBox('Users');

    var person = Person()
      ..name = 'Dave'
      ..age = 22
      ..friends = ['Linda', 'Marc', 'Anne'];

    await box.put('dave', person);

    print(box.get('dave')); // Dave: 22// Dave - 22
  }


  @override
  void initState() {
    setData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: new AppBar(
        title: Text("History"),
      ),
      body: Stack(
        children: [
          Container()
        ],
      )
    );
  }
}
