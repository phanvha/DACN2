import 'package:flutter/material.dart';

class Pothole {
   String id;
   String image;
   double latitude;
   double longitude;
   String note;



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