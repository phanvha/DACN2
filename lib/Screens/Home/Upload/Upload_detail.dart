import 'dart:convert';
import 'package:Poro/Components/fluttericon.dart';
import 'package:Poro/Screens/User/Widgets/app_textfield.dart';
import 'package:Poro/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  ScrollController _scrollController = new ScrollController();
  PanelController _panelController = new PanelController();

  uploadFileFromDio(Pothole pothole, File photoFile) async {
    var dio = new Dio();
    dio.options.baseUrl = APIClient.uploadURL;
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
            responseType: ResponseType.plain // or ResponseType.JSON
            ));
    print("Response status: ${response.statusCode}");
    print("Response data: ${response.data}");
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
  void setLocation() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _latLng = new LatLng(position.latitude, position.longitude);
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
                    _image == null
                        ? mainCardRull(context)
                        : mainCardImage(context, _image),
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
                    Lottie.asset("assets/images/upload.json",
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
            child: Icon(Icons.camera_alt_rounded,color: Colors.white),
            backgroundColor: kPrimaryColor,
            label: 'Camera',
            //labelStyle: TextTheme(fontSize: 18.0),
            onTap: () {
              print('Camera');
              getImageFromCamera();
            }
        ),
        SpeedDialChild(
          child: Icon(Icons.add_photo_alternate_sharp, color: Colors.white,),
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
        borderRadius: BorderRadius.circular(24),
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
            onTap: (){
              
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
  Container mainCardImage(context, File file) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor,
            offset: Offset(0.0, 3.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],

      ),
      child: Row(
        children: [
          Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(10),
              width: (MediaQuery.of(context).size.width - 80),
              height: 200,
              child: _image!=null?Image.file(
                _image,
                fit: BoxFit.fill,
              ): Center(child: CircularProgressIndicator(backgroundColor: Colors.blue,))
          ),
        ],
      ),
    );
  }
  Container cardBody(context, Size size, LatLng latLng) {
    return Container(
      child: Column(
        children: [
          Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(left: 30),
              width: size.width,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Latitude: ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              // ignore: unrelated_type_equality_checks
                              Text(
                                latLng == null || latLng == ''
                                    ? ""
                                    : latLng.latitude.toString(),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Text(
                                "Longitude: ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              // ignore: unrelated_type_equality_checks
                              Text(
                                latLng == null || latLng == ''
                                    ? ""
                                    : latLng.longitude.toString(),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),

                ],
              )),
          SizedBox(height: 20,),
          Container(
            width: size.width,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 30, bottom: 10),
            child: Text("Description: ", style: TextStyle(color: Colors.black.withOpacity(.4)),),
          ),
          _buildNoteField(),
          SizedBox(height: 20,),
          InkWell(
            onTap: (){
              setState(() {

              });
            },
            child: Ink(
              child: Container(
                width: size.width/2,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
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
                  style: TextStyle(color: kPrimaryLightColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildNoteField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10,),
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

        decoration: new InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,

            icon: Icon(Icons.comment, color: Colors.white,),
            labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            contentPadding:
            EdgeInsets.only(left: 0, bottom: 11, top: 11, right: 15),
            hintText: "Short description...",
          hintStyle: TextStyle(color: Colors.black.withOpacity(.3))
        ),
      )
    );
  }
  TextStyle textStyle(double size, FontWeight fontWeight, Color colorName) => TextStyle(
        fontFamily: 'Quicksand',
        color: colorName,
        fontSize: size,
        fontWeight: fontWeight,
      );
}
