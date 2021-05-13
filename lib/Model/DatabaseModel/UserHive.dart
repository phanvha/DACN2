import 'dart:io';

import 'package:hive/hive.dart';
@HiveType(typeId: 1)
class Person {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  @HiveField(2)
  List<String> friends;
  Person({ this.name,  this.age,  this.friends});

  @override
  String toString() {
    return '$name: $age';
  }
}
