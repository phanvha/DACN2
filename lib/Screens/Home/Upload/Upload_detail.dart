import 'dart:convert';
import 'package:Poro/Components/fluttericon.dart';
import 'package:Poro/Screens/User/Widgets/app_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:Poro/Model/pothole.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:Poro/constant.dart';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File _image;
  final picker = ImagePicker();
  String path = "";
  bool _isAppbar = true;
  bool _isUpload = true;
  ScrollController _scrollController = new ScrollController();
  PanelController _panelController = new PanelController();
  Pothole _pothole = Pothole();
  TextEditingController _noteController = TextEditingController();
  Key _key;
  bool visibilityTag = false;
  bool visibilityObs = false;

  void _changed(bool visibility, String field) {
    setState(() {
      if (field == "tag") {
        visibilityTag = visibility;
      }
      if (field == "obs") {
        visibilityObs = visibility;
      }
    });
  }

  uploadFileFromDio(
      Pothole pothole, File photoFile, BuildContext context) async {
    _isUpload = false;
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

    if (photoFile != null &&
        photoFile.path != null &&
        photoFile.path.isNotEmpty) {
      // Create a FormData
      String fileName = basename(photoFile.path);
      print("File Name : $fileName");
      print("File Size : ${photoFile.lengthSync()}");
      formData = FormData.fromMap(<String, dynamic>{
        "_id": pothole.id,
        "image":
            await MultipartFile.fromFile(photoFile.path, filename: fileName),
        "latitude": pothole.latitude,
        "longitude": pothole.longitude,
        "note": pothole.note
      });
    } else {
      print("Can't upload!");
    }
    var response = await dio.post("/api/create-pothole",
        data: formData,
        options: Options(
            method: 'POST',
            responseType: ResponseType.json // or ResponseType.JSON
            ));

    print("Response status: ${response.statusCode}");
    print("Response data: ${response.data}");
    if (response.data['code'] == 200) {
      _showToast(context, "Successfully!");
      setState(() {
        _isUpload = true;
      });
      print("Response data: ${response.data['message']}");
    } else {
      setState(() {
        _isUpload = true;
      });
      _showToast(context, "Failed!!!");
    }
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'OK',
          onPressed: scaffold.hideCurrentSnackBar,
          textColor: kPrimaryColor,
        ),
      ),
    );
  }

  getDialog(BuildContext context) {
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: 'Choose file?',
          negativeText: "Camera",
          positiveText: "Gallery",
          negativeTextStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
          positiveTextStyle:
              TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),
          onPositiveClick: () {
            getImageFromGallery();
            Navigator.of(context).pop();
          },
          onNegativeClick: () {
            getImageFromCamera();
            Navigator.of(context).pop();
          },
        );
      },
      animationType: DialogTransitionType.size,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        path = pickedFile.path;
        print(json.encode(path));
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        path = pickedFile.path;
        setState(() {
          _image = File(pickedFile.path);
        });
        print(json.encode(path));
      } else {
        print('No image selected.');
      }
    });
  }

  Position position;
  LatLng _latLng;
  String address;
  void setLocation() async {
    position = await Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;

    setState(() {
      _latLng = new LatLng(position.latitude, position.longitude);
      address = first.addressLine;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    setLocation();
    setState(() {
      if (_latLng != null) {
        _pothole.latitude = _latLng.latitude;
        _pothole.longitude = _latLng.longitude;
      }
      if (_image != null) {}
      _pothole.note = _noteController.text;
    });
    return SafeArea(
      child: Scaffold(
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
                    children: [
                      Text(' Upload Data',
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
                )),
          ),
          body: SlidingUpPanel(
              controller: _panelController,
              minHeight: size.height / 1.5,
              maxHeight: size.height / 1,
              onPanelClosed: () {
                appBarStatus(true);
              },
              onPanelOpened: () {
                appBarStatus(false);
              },
              panel: Container(
                height: size.height,
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                ),
                child: Column(
                  children: [
                    _image == null ? mainCardRull(context) : Container(),
                    // mainCard(context),
                    SizedBox(height: 15),
                    cardBody(context, size, _latLng)
                  ],
                ),
              ),
              // collapsed: Container(
              //   decoration:
              //       BoxDecoration(color: kPrimaryColor, borderRadius: radius),
              //   child: InkWell(
              //     onTap: () {
              //       _panelController.open();
              //     },
              //     child: Ink(
              //       child: Column(
              //         children: [
              //           // buildDragIcon(Colors.white),
              //           Container(
              //             child: Text(
              //               "More",
              //               style: TextStyle(
              //                 color: Colors.white,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              body: Container(
                color: kPrimaryColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _image != null
                        ? Image.file(_image,
                            width: size.width, height: 200, fit: BoxFit.cover)
                        : Lottie.asset("assets/images/upload.json",
                            height: 180, width: 180),
                  ],
                ),
              )),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: _getFAB()
          // floatingActionButton: FloatingActionButton(
          //
          //   tooltip: 'Pick Image',
          //   backgroundColor: kPrimaryColor,
          //   child: _getFAB(),
          // ),

          ),
    );
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // this is ignored if animatedIcon is non null
      // child: Icon(Icons.add),
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
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
            child: Icon(Icons.camera_alt_rounded, color: Colors.white),
            backgroundColor: kPrimaryColor,
            label: 'Camera',
            //labelStyle: TextTheme(fontSize: 18.0),
            onTap: () {
              print('Camera');
              getImageFromCamera();
            }),
        SpeedDialChild(
          child: Icon(
            Icons.add_photo_alternate_sharp,
            color: Colors.white,
          ),
          backgroundColor: Colors.blue,
          label: 'Gallery',
          //labelStyle: TextTheme(fontSize: 18.0),
          onTap: () {
            print('Gallery');
            getImageFromGallery();
          },
        ),
      ],
    );

    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      // animatedIconTheme: IconThemeData(size: 22),
      activeBackgroundColor: kPrimaryColor,
      activeForegroundColor: Colors.white,
      backgroundColor: kPrimaryColor,
      visible: true,
      curve: Curves.bounceIn,
      foregroundColor: Colors.white,
      overlayColor: Colors.white,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Icon(Icons.camera_alt),
            backgroundColor: kPrimaryColor,
            onTap: () {
              print("mmm");
              getImageFromCamera();
            },
            label: 'Camera',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: kPrimaryColor),
        // FAB 2
        SpeedDialChild(
            child: Icon(Icons.add_photo_alternate_outlined),
            backgroundColor: kPrimaryColor,
            onTap: () {
              getImageFromGallery();
            },
            label: 'Gallery',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: kPrimaryColor)
      ],
    );
  }

  Container mainCardRull(context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey[100],
        //     spreadRadius: 10,
        //     offset: Offset.zero,
        //     blurRadius: 20,
        //   ),
        // ],
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor,
            offset: Offset(0.0, 3.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              getDialog(context);
            },
            child: Ink(
              child: Container(
                alignment: Alignment.topCenter,
                width: (MediaQuery.of(context).size.width - 80) / 2,
                height: 130,
                child: Lottie.asset("assets/images/upload-files.json",
                    height: 150, width: 150),
              ),
            ),
          ),
          SizedBox(
            width: (MediaQuery.of(context).size.width - 80) / 2,
            height: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Upload your data',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Help warn of dangers where you are standing for other drivers',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Container mainCardImage(context, File file) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
  //     padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(24),
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: kPrimaryColor,
  //           offset: Offset(0.0, 3.0), //(x,y)
  //           blurRadius: 6.0,
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           alignment: Alignment.topCenter,
  //           padding: EdgeInsets.all(10),
  //           width: (MediaQuery.of(context).size.width - 80),
  //           height: 200,
  //           child: InteractiveViewer(
  //             panEnabled: false, // Set it to false
  //             boundaryMargin: EdgeInsets.all(100),
  //             minScale: 0.5,
  //             maxScale: 2,
  //             child: Image.file(
  //               _image,
  //               width: 200,
  //               height: 200,
  //               fit: BoxFit.cover,
  //             ),
  //           ),
  //           // child: _image!=null?Image.file(
  //           //   _image,
  //           //   fit: BoxFit.fill,
  //           // ): Center(child: CircularProgressIndicator(backgroundColor: Colors.blue,))
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Container cardBody(context, Size size, LatLng latLng) {
    return Container(
      child: Column(
        children: [
          Container(
            width: size.width,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 30, bottom: 10),
            child: Text(
              "Your location: ",
              style: TextStyle(color: Colors.black.withOpacity(.4)),
            ),
          ),
          Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: size.width / 1.2,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width - 80) / 1.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Address: ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            // ignore: unrelated_type_equality_checks
                            Text(
                              address == null || address == '' ? "" : address,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(.4),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              )),
          SizedBox(
            height: 20,
          ),
          Container(
            width: size.width,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 30, bottom: 10),
            child: Text(
              "Description: ",
              style: TextStyle(color: Colors.black.withOpacity(.4)),
            ),
          ),
          _buildNoteField(),
          SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              setState(() {});
              print(_pothole.latitude.toString() + "--" + _pothole.note);
              if (_image != null) {
                uploadFileFromDio(_pothole, _image, context);
              }
            },
            child: Ink(
              child: Container(
                width: size.width / 3,
                height: 45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor,
                      offset: Offset(0.0, 3.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                      color: kPrimaryLightColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          _isUpload == true
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                      child: CircularProgressIndicator(
                    backgroundColor: kPrimaryColor,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                  )),
                )
        ],
      ),
    );
  }

  Widget _buildNoteField() {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        margin: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(2),
        ),
        child: TextFormField(
          cursorColor: Colors.black,
          keyboardType: TextInputType.multiline,
          maxLength: 100,
          maxLines: null,
          autovalidate: true,
          controller: _noteController,
          onChanged: (value) {},
          decoration: new InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              icon: Icon(
                Icons.comment,
                color: Colors.white,
              ),
              labelStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              contentPadding:
                  EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
              hintText: "Short description...",
              hintStyle: TextStyle(color: Colors.black.withOpacity(.3))),
        ));
  }

  TextStyle textStyle(double size, FontWeight fontWeight, Color colorName) =>
      TextStyle(
        fontFamily: 'Quicksand',
        color: colorName,
        fontSize: size,
        fontWeight: fontWeight,
      );

  Widget dialog(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Image.asset('assets/images/apple.png', height: 100),
          Text(
            "Text 1",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            "Text 1",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 24.0),
          Align(
            alignment: Alignment.bottomCenter,
            child: Icon(Icons.cancel),
          ),
        ],
      ),
    );
  }
}
