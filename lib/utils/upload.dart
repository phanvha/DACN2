import 'package:Poro/Model/trackingModel.dart';
import 'package:Poro/constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

uploadPoint(BuildContext context, LatLng latLng) async {
  var dio = new Dio();
  dio.options.baseUrl = APIClient.baseURL;
  dio.options.connectTimeout = 5000; //5s
  dio.options.receiveTimeout = 5000;
  dio.options.headers['content-Type'] = 'application/json';
  FormData formData = new FormData();

  // formData.add("_id", pothole.id);
  // formData.add("latitude", pothole.latitude);
  // formData.add("longitude", pothole.longitude);
  // formData.add("note", pothole.note);

  formData = FormData.fromMap(<String, dynamic>{
    "latitude": latLng.latitude,
    "longitude": latLng.longitude,
  });
  var response = await dio.post(APIClient.trackingURL,
      data: formData,
      options: Options(
          method: 'POST',
          responseType: ResponseType.json // or ResponseType.JSON
      ));

  print("Response status: ${response.statusCode}");
  print("Response data: ${response.data}");
  if (response.data['code'] == 200) {
    print("Response data: ${response.data['message']}");
  } else {
    print("Response data: ${response.data['message']}");
  }
}