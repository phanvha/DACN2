import 'dart:convert';

import 'package:Poro/Api/api-clients.dart';
import 'package:Poro/Model/directDetails.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'dart:core';
import 'package:http/http.dart' as http;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

///Colors that we use in this app
const BackgroundColorLoading = Color(0xFF80D8FF);
const BackgroundColor = Color(0xFFFFFFFF);

const kBackgroundColor = Color(0xFFF8F8F8);
const kActiveIconColor = Color(0xFFE68342);
const kTextColor = Color(0xFF222B45);
const kBlueLightColor = Color(0xFFC7B8F5);
const kBlueColor = Color(0xFF817DC0);
const kShadowColor = Color(0xFFE6E6E6);
const kPrimaryColor = Color(0xFF278DA7);
const kPrimaryLightColor = Color(0xFF80D8FF);
const kBlueColorLight = Color(0xFF0095FF);
const API_KEY = "AIzaSyDjU96B-wALb-OUjV3ETE8yVEjJC1JPKhE";

const double kDefaultPadding = 20.0;

final kTtitleStyle = TextStyle(
  color: Colors.black,
  fontFamily: 'CM Sans Serif',
  fontSize: 26.0,
  height: 1.5
);

final kSubtitleStyle = TextStyle(
  color: Colors.black,
  fontSize: 18.0,
  height: 1.2
);

class Themes {
  static const Color colorHeader = Color(0xFF172B4D);
  static const Color colorPrimary = Color(0xFF0065FF);
}

class APIClient{
  static const String baseURL = "http://192.168.1.19:4040";
  static const String URL = "${baseURL}/api/potholes";
  static const String uploadURL = "${baseURL}/api/create-pothole";
  static const String imageURL = "${baseURL}/static/data/images/";
}

class Mylocation{

  Future<Position> getPosition() async {//call this async method from whereever you need

     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    debugPrint('location: ${position.latitude},${position.longitude}');

    return await position;
  }
  getAddress(Position position) async{
    double latitude=0;
    double longitude=0;
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    latitude = position.latitude;
    longitude = position.longitude;
    String address;
    address = first.countryName;
    // state.setState(() {
    //   // locationMessage = "Latitude: " +position.latitude.toString()+", Longtitude:"+position.longitude.toString();
    // });
    return address;
  }
}


class Maps {

}


