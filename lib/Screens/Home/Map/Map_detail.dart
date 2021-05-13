import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:Poro/Model/directionModel.dart';
import 'package:Poro/Model/directionRespository.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;

import 'package:Poro/Model/directDetails.dart';
import 'package:Poro/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';



class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker originMarker, destinationMarker;
  Circle circle;
  GoogleMapController _controller;
  PanelController panelController = new PanelController();
  LatLng originLatlng, destinateLatlng;
  static PolylinePoints _polylinePoints = PolylinePoints();
  static String point =
      "a~l~Fjk~uOnzh@vlbBtc~@tsE`vnApw{A`dw@~w\\|tNtqf@l{Yd_Fblh@rxo@b}@xxSfytAblk@xxaBeJxlcBb~t@zbh@jc|Bx}C`rv@rw|@rlhA~dVzeo@vrSnc}Axf]fjz@xfFbw~@dz{A~d{A|zOxbrBbdUvpo@`cFp~xBc`Hk@nurDznmFfwMbwz@bbl@lq~@loPpxq@bw_@v|{CbtY~jGqeMb{iF|n\\~mbDzeVh_Wr|Efc\\x`Ij{kE}mAb~uF{cNd}xBjp]fulBiwJpgg@|kHntyArpb@bijCk_Kv~eGyqTj_|@`uV`k|DcsNdwxAott@r}q@_gc@nu`CnvHx`k@dse@j|p@zpiAp|gEicy@`omFvaErfo@igQxnlApqGze~AsyRzrjAb__@ftyB}pIlo_BflmA~yQftNboWzoAlzp@mz`@|}_@fda@jakEitAn{fB_a]lexClshBtmqAdmY_hLxiZd~XtaBndgC";
  List<PointLatLng> result;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  Directions _info;

  Set<Marker> markers = Set();
  bool _isAppbar = true;

  var _originController = TextEditingController();
  var _destinateController = TextEditingController();
  var uuid = new Uuid();
  String _sessionToken;
  List<dynamic> _placeList = [];
  List<dynamic> _placeList2 = [];

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(15.983517, 108.252318),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/images/cursor.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      originLatlng = latlng;
      originMarker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 3,
          strokeColor: Colors.transparent,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  @override
  void initState() {
    // if (originLatlng != null && destinateLatlng != null) {
    //   _getPolyline(originLatlng, destinateLatlng);
    // }
    _originController.addListener(() {
      _onChanged(_originController);
    });
    _destinateController.addListener(() {
      _onChanged(_originController);
    });
  }

  void getSuggestion(String input) async {
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=${API_KEY}&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
        if(_placeList!=null){
          print("zzzzzzz");
        }
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  _onChanged(controller) {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    print("textt"+controller.text);
    getSuggestion(controller.text);
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);
      setState(() {});

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 5000.000,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void appBarStatus(bool status) {
    setState(() {
      _isAppbar = status;
    });
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setState(() {
      getCurrentLocation();
    });
    Set.of((originMarker != null) ? [originMarker] : []);
    return SafeArea(
      child: Scaffold(
        primary: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AnimatedContainer(
              height: _isAppbar ? 80.0 : 0.0,
              duration: Duration(milliseconds: 400),
              child: AppBar(
                elevation: 0,
                backgroundColor: Color(0xFF80D8FF),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Icon(
                    //   Icons.location_on_outlined,
                    //   color: Colors.white,
                    // ),
                    Text(' Maps',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Image.asset(
                      "assets/images/bell.png",
                      width: 24,
                    ),
                    onPressed: () {
                      // return Container(
                      //   child: Scaffold(
                      //     drawer: MainDrawer(),
                      //   ),
                      // );
                    },
                  ),
                ],
              )),
        ),
        body: SlidingUpPanel(
          controller: panelController,
          //backdropEnabled: true,
          //renderPanelSheet: true,
          parallaxEnabled: true,
          parallaxOffset: 0.7,
          //backdropTapClosesPanel: true,
          //isDraggable: true,
          minHeight: 0,
          maxHeight: size.height / 2.5,
          onPanelClosed: () {
            appBarStatus(true);
          },
          onPanelOpened: () {
            appBarStatus(false);
          },
          panel: Container(
            height: size.height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [Container()],
            ),
          ),

          body: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: EdgeInsets.only(),
              child: _getFAB(),
            ),
            body: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: initialLocation,
                  markers: {
                    if (originMarker != null) originMarker,
                    if (destinationMarker != null) destinationMarker
                  },
                  circles: Set.of((circle != null) ? [circle] : []),
                  onMapCreated: (GoogleMapController controller) {
                    _controller = controller;
                  },
                  polylines: {
                    if (_info != null)
                      Polyline(
                        polylineId: const PolylineId('overview_polyline'),
                        color: Colors.red,
                        width: 5,
                        points: _info.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                      ),
                  },
                  // polylines: {
                  //   if(point!=null) Polyline(
                  //     polylineId: const PolylineId('overview_polyline'),
                  //     color: Colors.red,
                  //     width: 5,
                  //     points: result.map((e) => LatLng(e.latitude, e.longitude))
                  //         .toList(),
                  //   )
                  // },
                  onTap: _handleTap,
                ),
                Positioned(
                    child: Stack(children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 170,
                            padding:
                                EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.only(top: 50),
                            width: size.width / 1.2,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: kShadowColor,
                                  offset: Offset(0.0, 4.0), //(x,y)
                                  blurRadius: 7.0,
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: TextField(
                                        controller: _originController,
                                        style: TextStyle(fontSize: 12),
                                        decoration: new InputDecoration(
                                          // border: new OutlineInputBorder(
                                          //     borderRadius: BorderRadius.circular(5),
                                          //     borderSide: new BorderSide(
                                          //       color: Colors.blue,
                                          //       width: 0,
                                          //     )),
                                          // enabledBorder: UnderlineInputBorder(
                                          //   borderSide: BorderSide(color: Colors.cyan,width: 1),
                                          // ),
                                          // focusedBorder: UnderlineInputBorder(
                                          //   borderSide: BorderSide(color: Colors.green, width: 3),
                                          // ),
                                          focusColor: Colors.blue,
                                          hintText: 'Origin...',
                                          labelStyle: TextStyle(fontSize: 12),
                                          //helperText: 'Keep it short, this is just a demo.',
                                          labelText: ' From ',
                                          prefixIcon: const Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.blue,
                                          ),
                                          prefixText: ' ',
                                          suffixText: '',
                                          // suffixStyle:
                                          //     const TextStyle(color: Colors.green)
                                        ),
                                      ),
                                      width:
                                          MediaQuery.of(context).size.width * 0.8,
                                    ),

                                  ],
                                ),

                                SizedBox(
                                  height: 2,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: TextField(
                                        controller: _destinateController,
                                        style: TextStyle(fontSize: 12),
                                        decoration: new InputDecoration(
                                          // border: new OutlineInputBorder(
                                          //     borderRadius: BorderRadius.circular(5),
                                          //     borderSide: new BorderSide(
                                          //       color: Colors.blue,
                                          //       width: 0,
                                          //     )),
                                          // enabledBorder: UnderlineInputBorder(
                                          //   borderSide: BorderSide(color: Colors.cyan,width: 1),
                                          // ),
                                          // focusedBorder: UnderlineInputBorder(
                                          //   borderSide: BorderSide(color: Colors.green, width: 3),
                                          // ),
                                          focusColor: Colors.blue,
                                          hintText: 'Destination...',
                                          labelStyle: TextStyle(fontSize: 12),
                                          //helperText: 'Keep it short, this is just a demo.',
                                          labelText: ' To ',
                                          prefixIcon: const Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.blue,
                                          ),
                                          prefixText: ' ',
                                          suffixText: '',
                                          // suffixStyle:
                                          //     const TextStyle(color: Colors.green)
                                        ),
                                      ),
                                      width:
                                      MediaQuery.of(context).size.width * 0.8,
                                    ),

                                  ],
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.history),
                                        onPressed: () {}),
                                    IconButton(
                                        icon: Icon(Icons.arrow_forward_sharp),
                                        onPressed: () {}),
                                  ],
                                )
                              ],
                            ),
                          ),

                          // IconButton(
                          //   icon: Icon(Icons.search, color: Colors.blue),
                          // )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 12.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellowAccent,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                            )
                          ],
                        ),
                        child: Text(
                          _info!=null?'${_info.totalDistance}, ${_info.totalDuration}':"",
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _placeList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_placeList[index]["description"]),
                          );
                        },
                      )
                    ],
                  ),

                ]))
              ],
            ),
          ),
        ),
      ),
    );
  }

  // final ArgumentCallback<LatLng> onTap;

  _handleTap(LatLng point) async {
    setState(() {
      destinateLatlng = point;
      destinationMarker = Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'Destination',
        ),
        // icon:
        //     BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      );
    });
    if (originLatlng != null && destinateLatlng != null) {
      final directions = await DirectionsRepository()
          .getDirections(origin: originLatlng, destination: destinateLatlng);
      setState(() => _info = directions);
    } else {
      print("nullllllll");
    }
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // this is ignored if animatedIcon is non null
      // child: Icon(Icons.add),
      marginBottom: 150,
      marginEnd: 30,
      visible: true,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: kPrimaryColor,
      animationSpeed: 300,
      elevation: 3.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(
            Icons.home_outlined,
            color: kPrimaryColor,
          ),
          backgroundColor: Colors.white,
          label: 'Home',
          labelStyle: TextStyle(color: kPrimaryColor),
          onTap: () {
            print('Home');

            Navigator.pop(context);
          },
        ),
        SpeedDialChild(
            child: Icon(Icons.search, color: kPrimaryColor),
            backgroundColor: Colors.white,
            label: 'Search',
            labelStyle: TextStyle(color: kPrimaryColor),
            onTap: () {
              print('Search');
              setState(() {
                panelController.open();
              });
            }),
        SpeedDialChild(
            child: Icon(Icons.refresh, color: kPrimaryColor),
            backgroundColor: Colors.white,
            label: 'Refresh',
            labelStyle: TextStyle(color: kPrimaryColor),
            onTap: () {
              print('Refresh');
              setState(() {
                if (panelController.isPanelOpen) {
                  panelController.close();
                }
                setState(() {});
              });
            }),
      ],
    );
  }
}

class ArbitrarySuggestionType {
  //For the mock data type we will use review (perhaps this could represent a restaurant);
  num stars;
  String name, imgURL;

  ArbitrarySuggestionType(this.stars, this.name, this.imgURL);
}
