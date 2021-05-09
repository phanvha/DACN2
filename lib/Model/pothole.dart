import 'package:flutter/material.dart';

class Pothole {
  final String id;
  final String image;
  final double latitude;
  final double longitude;
  final String note;



  Pothole({this.id, this.image, this.latitude, this.longitude, this.note, });

  factory Pothole.fromJson(Map<String, dynamic> json) {
    return Pothole(
      id: json['_id'] as String,
      image: json['image_url'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      note: json['note'] as String,
    );
  }
}