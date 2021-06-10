import 'dart:convert';

import 'package:Poro/Model/directDetails.dart';
import 'package:Poro/Model/pothole.dart';
import 'package:Poro/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Pothole>> fetchDataPotholes(http.Client client) async {
  print("object");
  final response = await client
      .get(Uri.parse(APIClient.URL));
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseDataPotholes, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Pothole> parseDataPotholes(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Pothole>((json) => Pothole.fromJson(json)).toList();
}

// Future<List<DirectionDetails>> getResultDirection(http.Client client, String url) async{
//   print("getResultDirection");
//   final response = await client.get(Uri.parse(url));
//   print(response.body.toString()+"mm");
//   // Use the compute function to run parsePhotos in a separate isolate.
//   return compute(parseDataDirection,response.body);
// }
// List<Pothole> parseDataDirection(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//
//   return parsed.map<DirectionDetails>((json) => DirectionDetails.fromJson(json)).toList();
// }
