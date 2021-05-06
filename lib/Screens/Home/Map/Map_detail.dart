import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _mapScreenState createState() => _mapScreenState();
    // TODO: implement createState
}

class _mapScreenState extends State<MapScreen> {
  var locationMessage = "";
  void getCurrentLocation() async {
    var position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator().getLastKnownPosition();
    print(lastPosition);
    var lat = position.latitude;
    var long = position.longitude;
    setState(() {
      locationMessage = "Latitude: $lat, Longtitude: $long";
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Location Services"),
      ),
      body: Center (
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              size: 46.0,
              color: Colors.blue,
            ),
            SizedBox(height: 10.0),
            Text(
              "Get user location",
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
              Text("Position: $locationMessage"),
            FlatButton(
              onPressed: () {
                getCurrentLocation();
              },
              color: Colors.blue[800],
              child: Text(
                "Get current location",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}