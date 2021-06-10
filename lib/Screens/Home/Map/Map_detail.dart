import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:Poro/Api/api-clients.dart';
import 'package:Poro/Model/directionModel.dart';
import 'package:Poro/Model/directionRespository.dart';
import 'package:Poro/Model/pothole.dart';
import 'package:Poro/Notifier/ChangeNotifier.dart';
import 'package:Poro/Screens/Home/About/Backend/Backend_profile.dart';
import 'package:Poro/Screens/Home/About/Frontend/frontend_profile.dart';
import 'package:Poro/main.dart';
import 'package:Poro/utils/dialog-combobox.dart';
import 'package:Poro/utils/sensor.dart';
import 'package:Poro/utils/upload.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:custom_dialog/custom_dialog.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import 'package:shake/shake.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:tabbar/tabbar.dart';
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
  List<Pothole> _listPothole;
  ShakeDetector _shakeDetector;
  CustomDialogBox customDialogBox;
  Timer timer;
  PageController _pageController;

  Set<Marker> markers = Set();
  Set<Marker> markers2 = Set();
  bool _isAppbar = true;
  LatLng currentPoint, mainPoint, startPoint, endPoint;

  var _originController = TextEditingController();
  var _destinateController = TextEditingController();
  var uuid = new Uuid();
  String _sessionToken1, _sessionToken2;
  List<dynamic> _placeList = [];
  List<dynamic> _placeList2 = [];
  bool state1, state2;
  bool _visible = false, _visibleSearch = true;
  bool isSuggest1 = false, isSuggest2 = false;
  bool statusCurrentLocation = true;
  bool visiblePinRed = false, visiblePinBlue = false;

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
    if (originMarker != null) {
      Marker marker = markers.firstWhere(
          (marker) => marker.markerId.value == "A",
          orElse: () => null);
      setState(() {
        markers.remove(marker);
      });
    }
    this.setState(() {
      LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
      originLatlng = latlng;
      originMarker = Marker(
          markerId: MarkerId("A"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      markers.add(originMarker);

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
    if (statusCurrentLocation) {
      getCurrentLocation();
    }

    startGetDataMarker();

    // _originController.addListener(() {
    //   _onChangedOrigin(_originController);
    //   // state1 = !state1;
    // });
    // _destinateController.addListener(() {
    //   _onChangedDestinate(_destinateController);
    //   // state2 = !state2;
    // });
    getShake(context);
    checkDistance();

  }

  void checkDistance() async {
    _listPothole = await fetchDataPotholes(http.Client());
    if(_listPothole!=null) {
      _listPothole.forEach((element) {
        double distanceInMeters = Geolocator.distanceBetween(
            currentPoint.latitude, currentPoint.longitude, element.latitude,
            element.longitude);
        if (distanceInMeters < 500) {
          print("Alert: " + distanceInMeters.toString());
          // showDialog(
          //     context: context,
          //     builder: (BuildContext context) {
          //       customDialogBox = new CustomDialogBox(
          //         title: "Be Careful!",
          //         descriptions: "Bạn đang di chuyển ở gần nơi có mặt đường xấu! \n Giảm tốc độ và chú ý quan sát",
          //         text: "",
          //         callback: (){},
          //       );
          //       return customDialogBox;
          //     }
          // );
        } else {
          print("Alert: NOOO");
        }
      });
    }else{
      print("_listPothole = null");
    }
  }

  void getShake(context) {
    _shakeDetector = ShakeDetector.waitForStart(onPhoneShake: () {
      // Do stuff on phone shake
      print("Shaking...");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            customDialogBox = new CustomDialogBox(
              title: "Hey!",
              descriptions: "Are you moving on a bad field?",
              text: "Yes",
              callback: () {
                uploadPoint(context, currentPoint);
              },
            );
            return customDialogBox;
          }
          );
    });
    setState(() {
      _shakeDetector.startListening();
    });
  }

  void getSuggestion(String input, int state) async {
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=${API_KEY}&sessiontoken=$_sessionToken1';
    var response1 = await http.get(Uri.parse(request));

    if (response1.statusCode == 200) {
      setState(() {
        if (state == 0) {
          isSuggest1 = !isSuggest1;
          _placeList = json.decode(response1.body)['predictions'];
        }
        if (_placeList != null) {
          print("_placeList: null");
        }
      });
      String request2 =
          '$baseURL?input=$input&key=${API_KEY}&sessiontoken=$_sessionToken2';
      var response2 = await http.get(Uri.parse(request2));
      if (response2.statusCode == 200) {
        setState(() {
          if (state == 1) {
            isSuggest2 = !isSuggest2;
            _placeList2 = json.decode(response2.body)['predictions'];
          }
          if (_placeList2 != null) {
            print("_placeList2: null");
          }
        });
      }
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  // _onChangedOrigin(controller) {
  //   if (_sessionToken1 == null) {
  //     setState(() {
  //       _sessionToken1 = uuid.v4();
  //     });
  //   }
  //   _placeList2.clear;
  //   print("Text1: " + controller.text);
  //   getSuggestion(controller.text, 0);
  // }
  //
  // _onChangedDestinate(controller) {
  //   if (_sessionToken2 == null) {
  //     setState(() {
  //       _sessionToken2 = uuid.v4();
  //     });
  //   }
  //   _placeList.clear;
  //   print("text2" + controller.text);
  //   getSuggestion(controller.text, 1);
  // }

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
        currentPoint =
            new LatLng(newLocalData.latitude, newLocalData.longitude);
        if (_controller != null) {
          if (statusCurrentLocation == true) {
            _controller.animateCamera(CameraUpdate.newCameraPosition(
                new CameraPosition(
                    bearing: 5000.000,
                    target:
                        LatLng(newLocalData.latitude, newLocalData.longitude),
                    tilt: 0,
                    zoom: 17.0)));
          }

          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void moveCameraPosition(originLatlng) {
    _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
        bearing: 5000.000,
        target: LatLng(originLatlng.latitude, originLatlng.longitude),
        tilt: 0,
        zoom: 10.0)));
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
    _originController.dispose();
    _destinateController.dispose();
    timer.cancel();
    super.dispose();
  }

  void startGetDataMarker() async {
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      setState(() {
        setMarker();
      });
    });
  }

  void setMarker() async {
    // AppState().fetchDataPotholes(http.Client()).then((value){setState(() {
    //   _listPothole = value;
    // });});

    if (_listPothole != null) {
      Marker marker = markers.firstWhere(
          (marker) => marker.markerId.value == "P",
          orElse: () => null);
      setState(() {
        markers.remove(marker);
      });
    }
    _listPothole = await fetchDataPotholes(http.Client());
    if (_listPothole != null) {
      print("got a data!");
      _listPothole.forEach((element) {
        Marker marker = new Marker(
            markerId: MarkerId(element.id),
            position: LatLng(element.latitude, element.longitude),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: element.note));
        markers2.add(marker);
      });
      setState(() {
        markers = markers2;
      });
    } else {
      print("Can't get data");
    }
  }

  void setToSearch() async {
    if (startPoint != null && endPoint != null) {
      final directions = await DirectionsRepository()
          .getDirections(origin: startPoint, destination: endPoint);
      if (directions != null) {
        setState(() => _info = directions);
        startPoint = endPoint = null;
        visiblePinRed = visiblePinBlue = false;
      } else {
        print("Can't get data");
        startPoint = endPoint = null;
        visiblePinRed = visiblePinBlue = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setState(() {
      //setMarker();
      setToSearch();
    });
    //startGetDataMarker();
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
            child: Column(
              children: [
                SizedBox(height: 5),
                Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2)),
                    child: Container()),
                DefaultTabController(
                  length: 3,
                  child: SizedBox(
                    height: size.height/2.5-9,
                    child: Column(
                      children: <Widget>[
                        TabBar(

                          tabs: <Widget>[
                            Tab(
                              icon: Icon(Icons.directions_car, color: kPrimaryColor,),
                            ),
                            Tab(
                              icon: Icon(Icons.directions_bike, color: kPrimaryColor,),
                            ),
                            Tab(
                              icon: Icon(Icons.directions_walk, color: kPrimaryColor,),
                            )
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: <Widget>[
                              _info!=null?
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.trending_up_rounded, size: 24, color: Colors.grey,),
                                            SizedBox(width: 10,),
                                            Text("Distance: ", style: TextStyle(fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        SizedBox(width: 20,),
                                        Text(_info != null
                                            ? '${_info.totalDistance}'
                                            : "",
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.timer, size: 24, color: Colors.grey,),
                                            SizedBox(width: 10,),
                                            Text("Time: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        SizedBox(width: 20,),
                                        Text(_info != null
                                            ? '${_info.totalDuration}'
                                            : "",
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10, left: 0, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(

                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("From: ", style: TextStyle(
                                                color: kPrimaryLightColor
                                              ),),
                                              Container(
                                                padding: EdgeInsets.only(top: 5, left: 10, bottom: 0),
                                                child: Text(_info != null
                                                    ? "Address..."
                                                    : "Address...",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(height: 2, color: Colors.grey,),
                                    Container(
                                      padding: EdgeInsets.only(top: 10, left: 0, bottom: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(

                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("To: ", style: TextStyle(
                                                  color: Colors.red
                                              ),),
                                              Container(
                                                padding: EdgeInsets.only(top: 5, left: 10, bottom: 0),
                                                child: Text(_info != null
                                                    ? "Address..."
                                                    : "Address...",
                                                  overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                ),),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),


                                  ],
                                ),
                              ):Container(alignment: Alignment.center,child: CircularProgressIndicator(),),
                              _info!=null?
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.trending_up_rounded, size: 24, color: Colors.grey,),
                                            SizedBox(width: 10,),
                                            Text("Distance: ", style: TextStyle(fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        SizedBox(width: 20,),
                                        Text(_info != null
                                            ? '${_info.totalDistance}'
                                            : "",
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.timer, size: 24, color: Colors.grey,),
                                            SizedBox(width: 10,),
                                            Text("Time: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        SizedBox(width: 20,),
                                        Text(_info != null
                                            ? '${_info.totalDuration}'
                                            : "",
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10, left: 0, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(

                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("From: ", style: TextStyle(
                                                  color: kPrimaryLightColor
                                              ),),
                                              Container(
                                                padding: EdgeInsets.only(top: 5, left: 10, bottom: 0),
                                                child: Text(_info != null
                                                    ? "Address..."
                                                    : "Address...",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(height: 2, color: Colors.grey,),
                                    Container(
                                      padding: EdgeInsets.only(top: 10, left: 0, bottom: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(

                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("To: ", style: TextStyle(
                                                  color: Colors.red
                                              ),),
                                              Container(
                                                padding: EdgeInsets.only(top: 5, left: 10, bottom: 0),
                                                child: Text(_info != null
                                                    ? "Address..."
                                                    : "Address...",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                  ),),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),


                                  ],
                                ),
                              ):Container(alignment: Alignment.center,child: CircularProgressIndicator(),),
                              _info!=null?
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.trending_up_rounded, size: 24, color: Colors.grey,),
                                            SizedBox(width: 10,),
                                            Text("Distance: ", style: TextStyle(fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        SizedBox(width: 20,),
                                        Text(_info != null
                                            ? '${_info.totalDistance}'
                                            : "",
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.timer, size: 24, color: Colors.grey,),
                                            SizedBox(width: 10,),
                                            Text("Time: ",style: TextStyle(fontWeight: FontWeight.bold),),
                                          ],
                                        ),
                                        SizedBox(width: 20,),
                                        Text(_info != null
                                            ? '${_info.totalDuration}'
                                            : "",
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 10, left: 0, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(

                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("From: ", style: TextStyle(
                                                  color: kPrimaryLightColor
                                              ),),
                                              Container(
                                                padding: EdgeInsets.only(top: 5, left: 10, bottom: 0),
                                                child: Text(_info != null
                                                    ? "Address..."
                                                    : "Address...",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(height: 2, color: Colors.grey,),
                                    Container(
                                      padding: EdgeInsets.only(top: 10, left: 0, bottom: 0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(

                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("To: ", style: TextStyle(
                                                  color: Colors.red
                                              ),),
                                              Container(
                                                padding: EdgeInsets.only(top: 5, left: 10, bottom: 0),
                                                child: Text(_info != null
                                                    ? "Address..."
                                                    : "Address...",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                  ),),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),


                                  ],
                                ),
                              ):Container(alignment: Alignment.center,child: CircularProgressIndicator(),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                  markers: markers,

                  // markers: {
                  //   if (originMarker != null) originMarker,
                  //   if (destinationMarker != null) destinationMarker,
                  //
                  // },
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
                  onCameraMove: (position) {
                    //print("lat"+ position.target.latitude.toString()+" lng: "+position.target.longitude.toString());
                    setState(() {
                      mainPoint = new LatLng(
                          position.target.latitude, position.target.longitude);
                    });
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
                Positioned.fill(
                    child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                        padding: EdgeInsets.only(right: 15),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 200,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    visiblePinBlue = !visiblePinBlue;
                                    visiblePinRed = false;
                                  });
                                },
                                child: Text(
                                  'From',
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  elevation: 3,
                                  primary: Colors.white,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    visiblePinBlue = false;
                                    visiblePinRed = !visiblePinRed;
                                  });
                                },
                                child: Text(
                                  'To',
                                  style: TextStyle(color: Colors.red),
                                ),
                                style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  elevation: 3,
                                  primary: Colors.white,
                                ),
                              ),
                            ]))
                  ],
                )),
                Positioned(
                    child: Stack(children: <Widget>[
                  visiblePinBlue == true
                      ? Container(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: 0, bottom: 200),
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
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  startPoint = mainPoint;
                                  visiblePinBlue = false;
                                  visiblePinRed = true;
                                });
                              },
                              child: Ink(
                                child: Text(
                                  "Confirm original",
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: visiblePinBlue,
                    child: Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/pin_blue.svg',
                        width: 32,
                      ),
                    ),
                  ),
                  visiblePinRed == true
                      ? Container(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: 0, bottom: 200),
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
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  endPoint = mainPoint;
                                  visiblePinBlue = true;
                                  visiblePinRed = false;
                                });
                              },
                              child: Ink(
                                child: Text(
                                  "Confirm Destination",
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: visiblePinRed,
                    child: Container(
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        'assets/images/pin_red.svg',
                        width: 32,
                      ),
                    ),
                  ),
                  Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: _visibleSearch,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 170,
                              padding: EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 20),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: TextField(
                                          controller: _originController,
                                          style: TextStyle(fontSize: 12),
                                          onTap: () {
                                            setState(() {
                                              if (_originController.text !=
                                                  "My Location") {
                                                _visible = !_visible;
                                              }
                                            });
                                          },
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
                                            //suffixText: '',
                                            suffixIcon:
                                                _originController.text.length >
                                                        0
                                                    ? IconButton(
                                                        onPressed: () =>
                                                            _originController
                                                                .clear(),
                                                        icon: Icon(
                                                          Icons.clear,
                                                          size: 18,
                                                        ),
                                                      )
                                                    : Container(),
                                            // suffixStyle:
                                            //     const TextStyle(color: Colors.green)
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: TextField(
                                          controller: _destinateController,
                                          style: TextStyle(fontSize: 12),
                                          decoration: new InputDecoration(
                                            focusColor: Colors.blue,
                                            hintText: 'Destination...',
                                            labelStyle: TextStyle(fontSize: 12),
                                            //helperText: 'Keep it short, this is just a demo.',
                                            labelText: ' To ',
                                            prefixIcon: const Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                            ),
                                            prefixText: ' ',
                                            suffixText: '',
                                            suffixIcon: _destinateController
                                                        .text.length >
                                                    0
                                                ? IconButton(
                                                    onPressed: () =>
                                                        _destinateController
                                                            .clear(),
                                                    icon: Icon(
                                                      Icons.clear,
                                                      size: 18,
                                                    ),
                                                  )
                                                : Container(),
                                            // suffixStyle:
                                            //     const TextStyle(color: Colors.green)
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.history),
                                          onPressed: () {}),
                                      IconButton(
                                          icon: Icon(Icons.arrow_forward_sharp),
                                          onPressed: () {
                                            setState(() async {
                                              if (_originController
                                                          .text.length !=
                                                      0 &&
                                                  _destinateController
                                                          .text.length !=
                                                      0) {
                                                if (_originController.text ==
                                                    "My Location") {
                                                  final directions =
                                                      await DirectionsRepository()
                                                          .getDirectionsByAddress(
                                                              null,
                                                              _destinateController
                                                                  .text,
                                                              originLatlng,
                                                              null);
                                                  setState(() => _info = directions);
                                                } else {
                                                  final directions =
                                                      await DirectionsRepository()
                                                          .getDirectionsByAddress(
                                                              _originController
                                                                  .text,
                                                              _destinateController
                                                                  .text,
                                                              null,
                                                              null);
                                                  setState(() {
                                                    _info = directions;
                                                    statusCurrentLocation =
                                                        false;
                                                    LatLng a = new LatLng(
                                                        _info.polylinePoints
                                                            .first.latitude,
                                                        _info.polylinePoints
                                                            .first.longitude);
                                                    moveCameraPosition(a);
                                                  });
                                                }
                                              } else {
                                                print("nullllllll");
                                              }
                                              _visibleSearch = !_visibleSearch;
                                              panelController.open();
                                            });
                                          }),
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
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: _visible,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _originController.text = "My Location";
                                _visible = !_visible;
                              });
                            },
                            child: Ink(
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 10, left: 30, right: 30),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                color: Colors.white.withOpacity(.7),
                                child: Row(
                                  children: [
                                    Icon(Icons.location_history,
                                        color: Colors.green),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("My Location")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _info != null
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            margin: EdgeInsets.only(top: 20, bottom: 150),
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
                              _info != null
                                  ? '${_info.totalDistance}, ${_info.totalDuration}'
                                  : "",
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      : Container(),
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
      Marker marker = markers.firstWhere(
          (marker) => marker.markerId.value == "B",
          orElse: () => null);
      markers.remove(marker);
      destinateLatlng = point;
      destinationMarker = Marker(
        markerId: MarkerId("B"),
        position: point,
        infoWindow: InfoWindow(
          title: 'Destination',
        ),
        // icon:
        //     BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      );

      markers.add(destinationMarker);
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
                //panelController.open();
                _visibleSearch = !_visibleSearch;
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
                } else {
                  panelController.open();
                }
                setState(() {});
              });
            }),
        SpeedDialChild(
            child: statusCurrentLocation
                ? Icon(Icons.remove_red_eye_outlined, color: kPrimaryColor)
                : Icon(Icons.remove_red_eye, color: kPrimaryColor),
            backgroundColor: Colors.white,
            label: 'Eye',
            labelStyle: TextStyle(color: kPrimaryColor),
            onTap: () {
              print('Eye');
              setState(() {
                statusCurrentLocation = !statusCurrentLocation;
              });
            }),
      ],
    );
  }
}
