import 'package:flutter/material.dart';

class trackingModel {
  String id;
  double latitude;
  double longitude;



  trackingModel({this.id, this.latitude, this.longitude });

  factory trackingModel.fromJson(Map<String, dynamic> json) {
    return trackingModel(
      id: json['_id'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }
}