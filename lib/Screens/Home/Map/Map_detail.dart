import 'dart:async';
import 'dart:collection';
import 'dart:ffi';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';

import 'package:Poro/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _isAppbar = true;
  ScrollController _scrollController = new ScrollController();
  PanelController _panelController = new PanelController();
  OverlayEntry _popupDialog;
  LatLng latLng = new LatLng(15.974611, 108.251378);
  GoogleMapController mapController;
  BitmapDescriptor customIcon;
  Set<Marker> _markers = {};
  Position _position = new Position(latitude: 15.974611, longitude: 108.251378);
  Position currentPosition;
  var geolocotor = Geolocator();
  Completer<GoogleMapController> _completerGoogleMap = Completer();
  GoogleMapController _googleMapController;
  String _address;

  void locatePosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLng, zoom: 15);
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    final coordinates =
        new Coordinates(currentPosition.latitude, currentPosition.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    setState(() {
      _address = first.addressLine;
    });
  }

  void localUser() async {
    double latitude = 0;
    double longitude = 0;
    final coordinates =
        new Coordinates(currentPosition.latitude, currentPosition.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");

    String address;
    address = first.countryName;
    print(address.toString());
    print(first.addressLine);
  }

  Size sizee = new Size(24, 24);
  Marker marker;

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.userScrollDirection ==
    //       ScrollDirection.reverse) {
    //     appBarStatus(false);
    //   }
    //   if (_scrollController.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //     appBarStatus(true);
    //   }
    // });
    //parseIcon();
  }

  void appBarStatus(bool status) {
    setState(() {
      _isAppbar = status;
    });
  }
  // void parseIcon() async {
  //   //customIcon = await getMarkerIcon("assets/images/avata.png", sizee);
  //   customIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(), "assets/images/store.png");
  //   customIcon = await BitmapDescriptor.fromBytes(getBytesFromAsset("assets/images/store.png", width))
  //
  // }

  // Future < Uint8List > getBytesFromCanvas(int width, int height, urlAsset) async {
  //   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  //   final Canvas canvas = Canvas(pictureRecorder);
  //   final Paint paint = Paint()..color = Colors.transparent;
  //   final Radius radius = Radius.circular(50.0);
  //   canvas.drawRRect(
  //       RRect.fromRectAndCorners(
  //         Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
  //         topLeft: radius,
  //         topRight: radius,
  //         bottomLeft: radius,
  //         bottomRight: radius,
  //       ),
  //       paint);
  //
  //   final ByteData datai = await rootBundle.load(urlAsset);
  //
  //   var imaged = await loadImage(new Uint8List.view(datai.buffer));
  //
  //   canvas.drawImage(imaged, new Offset(0, 0), new Paint());
  //
  //   final img = await pictureRecorder.endRecording().toImage(width, height);
  //   final data = await img.toByteData(format: ui.ImageByteFormat.png);
  //   return data.buffer.asUint8List();
  // }
  // Future<Uint8List> getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec =
  //   await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  // }
  //
  // Future < ui.Image > loadImage(List < int > img) async {
  //   final Completer < ui.Image > completer = new Completer();
  //   ui.decodeImageFromList(img, (ui.Image img) {
  //
  //     return completer.complete(img);
  //   });
  //   return completer.future;
  // }
  //
  // //////
  // Future<ui.Image> getImageFromPath(String imagePath) async {
  //   File imageFile = File(imagePath);
  //
  //   Uint8List imageBytes = imageFile.readAsBytesSync();
  //
  //   final Completer<ui.Image> completer = new Completer();
  //
  //   ui.decodeImageFromList(imageBytes, (ui.Image img) {
  //     return completer.complete(img);
  //   });
  //
  //   return completer.future;
  // }
  //
  // Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
  //   final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  //   final Canvas canvas = Canvas(pictureRecorder);
  //
  //   final Radius radius = Radius.circular(size.width / 2);
  //
  //   final Paint tagPaint = Paint()..color = Colors.blue;
  //   final double tagWidth = 40.0;
  //
  //   final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
  //   final double shadowWidth = 15.0;
  //
  //   final Paint borderPaint = Paint()..color = Colors.white;
  //   final double borderWidth = 3.0;
  //
  //   final double imageOffset = shadowWidth + borderWidth;
  //
  //   // Add shadow circle
  //   canvas.drawRRect(
  //       RRect.fromRectAndCorners(
  //         Rect.fromLTWH(0.0, 0.0, size.width, size.height),
  //         topLeft: radius,
  //         topRight: radius,
  //         bottomLeft: radius,
  //         bottomRight: radius,
  //       ),
  //       shadowPaint);
  //
  //   // Add border circle
  //   canvas.drawRRect(
  //       RRect.fromRectAndCorners(
  //         Rect.fromLTWH(shadowWidth, shadowWidth,
  //             size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
  //         topLeft: radius,
  //         topRight: radius,
  //         bottomLeft: radius,
  //         bottomRight: radius,
  //       ),
  //       borderPaint);
  //
  //   // Add tag circle
  //   canvas.drawRRect(
  //       RRect.fromRectAndCorners(
  //         Rect.fromLTWH(size.width - tagWidth, 0.0, tagWidth, tagWidth),
  //         topLeft: radius,
  //         topRight: radius,
  //         bottomLeft: radius,
  //         bottomRight: radius,
  //       ),
  //       tagPaint);
  //
  //   // Add tag text
  //   TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
  //   textPainter.text = TextSpan(
  //     text: '1',
  //     style: TextStyle(fontSize: 20.0, color: Colors.white),
  //   );
  //
  //   textPainter.layout();
  //   textPainter.paint(
  //       canvas,
  //       Offset(size.width - tagWidth / 2 - textPainter.width / 2,
  //           tagWidth / 2 - textPainter.height / 2));
  //
  //   // Oval for the image
  //   Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
  //       size.width - (imageOffset * 2), size.height - (imageOffset * 2));
  //
  //   // Add path for oval image
  //   canvas.clipPath(Path()..addOval(oval));
  //
  //   // Add image
  //   ui.Image image = await getImageFromPath(
  //       imagePath); // Alternatively use your own method to get the image
  //   paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);
  //
  //   // Convert canvas to image
  //   final ui.Image markerAsImage = await pictureRecorder
  //       .endRecording()
  //       .toImage(size.width.toInt(), size.height.toInt());
  //
  //   // Convert image to bytes
  //   final ByteData byteData =
  //   await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  //   final Uint8List uint8List = byteData.buffer.asUint8List();
  //
  //   return BitmapDescriptor.fromBytes(uint8List);
  // }

  void _onMapCreated(mapC) async {
    //final Uint8List markerIcond = await getBytesFromCanvas(100,100,"assets/images/store.png");
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("id"),
        position: LatLng(15.974611, 108.251378),
        // icon: BitmapDescriptor.fromBytes(markerIcond),
        infoWindow: InfoWindow(
          title: "Hello! hà đây :))",
          snippet: '*',
        ),
        // icon: getMarkerIcon("", Size(150.0, 150.0)),
        onTap: () {},
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Mylocation().getPosition().then((value) {
      _position = value;
      setState(() {
        _position = value;
      });
    });
    print("ss" + _position.latitude.toString());
    return Container(
      color: kPrimaryLightColor,
      child: SafeArea(
        child: Scaffold(
          primary: true,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: AnimatedContainer(
              height: _isAppbar ? 80.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: AppBar(
                elevation: 0,
                backgroundColor: kPrimaryColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                    ),
                    Text("Da nang",
                        maxLines: 1,

                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 18,

                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      // return Container(
                      //   child: Scaffold(
                      //     drawer: MainDrawer(),
                      //   ),
                      // );
                    },
                  ),
                ],
              ),
            ),
          ),
          body: SlidingUpPanel(
            controller: _panelController,
            minHeight: 50,
            maxHeight: size.height / 1.5,
            borderRadius: radius,
            onPanelClosed: () {
              appBarStatus(true);
            },
            onPanelOpened: () {
              appBarStatus(false);
            },
            panel: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: radius,
              ),
              child: Column(
                children: [
                  buildDragIcon(Colors.blueGrey),
                  Container(
                    child: Text(
                      "hello",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            collapsed: Container(
              decoration:
                  BoxDecoration(color: kPrimaryLightColor, borderRadius: radius),
              child: InkWell(
                onTap: () {
                  _panelController.open();
                },
                child: Ink(
                  child: Column(
                    children: [
                      buildDragIcon(Colors.white),
                      Container(
                        child: Text(
                          "More",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: MediaQuery.of(context).size.width,
              child: Stack(children: <Widget>[
                GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: _position != null
                            ? LatLng(_position.latitude, _position.longitude)
                            : LatLng(15.974611, 108.251378),
                        zoom: 15),
                    mapType: MapType.normal,
                    // markers: _markers,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _completerGoogleMap.complete(controller);
                      _googleMapController = controller;
                      locatePosition();
                      localUser();
                      setState(() {
                        locatePosition();
                      });
                    }),
                Positioned(
                    child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.topLeft,

                    child: Padding(

                      padding: EdgeInsets.only(top: 20, left: 10),
                      child: Container(
                        height: size.height/5,
                        width: size.width/1.4,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Icon(Icons.location_on)
                          ],
                        ),
                      ),
                    ),
                  ),
                ))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildDragIcon(Color color) {
  return Container(
    decoration: BoxDecoration(
        color: color.withOpacity(.8), borderRadius: BorderRadius.circular(8)),
    height: 8,
    width: 50,
    margin: EdgeInsets.symmetric(vertical: 3),
  );
}
