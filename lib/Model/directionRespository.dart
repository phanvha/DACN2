import 'package:Poro/Model/directionModel.dart';
import 'package:Poro/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';

  final Dio _dio;

  DirectionsRepository({Dio dio}) : _dio = dio ?? Dio();

  Future<Directions> getDirections({@required LatLng origin, @required LatLng destination,}) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': API_KEY,
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
  Future<Directions> getDirectionsByAddress(String originString,String destinationString,LatLng originLatlng,  LatLng destinationLatlng,) async {
     var response;
    if(originString!=null){
       response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': originString,
          'destination': destinationString,
          'key': API_KEY,
        },
      );
    }else{
      response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'origin': '${originLatlng.latitude},${originLatlng.longitude}',
          'destination': destinationString,
          'key': API_KEY,
        },
      );
    }



    // Check if response is successful
    if (response.statusCode == 200) {
      return Directions.fromMap(response.data);
    }
    return null;
  }
}