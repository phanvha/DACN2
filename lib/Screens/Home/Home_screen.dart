import 'package:Poro/Screens/History/history-screen.dart';
import 'package:Poro/Screens/Home/About/About_detail.dart';
import 'package:Poro/Screens/Home/Contact/Contact_detail.dart';
import 'package:Poro/Screens/Home/Map/Map_detail.dart';
import 'package:Poro/Screens/Home/Upload/Upload_detail.dart';
import 'package:Poro/Screens/Home/Widgets/CardView.dart';
import 'package:Poro/Screens/Home/Widgets/category_card.dart';
import 'package:Poro/Screens/SideBar/Sidebar_screen.dart';
import 'package:Poro/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {

  bool _isAppbar = true;
  ScrollController _scrollController = new ScrollController();
  PanelController _panelController = new PanelController();


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

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(5.0),
    topRight: Radius.circular(5.0),
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    FlutterStatusbarcolor.setStatusBarColor(Colors.green[400]);

    // TODO: implement build
    return Container(
      // color: kPrimaryColor,
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
                  backgroundColor: Color(0xFF80D8FF),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      ),
                      Text(' DaNang, VietNam',
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
              controller: _panelController,
              minHeight: size.height / 1.8,
              maxHeight: size.height / 1.5,
              borderRadius: BorderRadius.circular(0),
              onPanelClosed: () {
                appBarStatus(true);
              },
              onPanelOpened: () {
                appBarStatus(false);
              },
              panel: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: kPrimaryColor.withOpacity(.8),
                ),
                child: Column(
                  children: [
                    mainCard(context),
                    SizedBox(height: 20),
                    GridView.count(
                      crossAxisSpacing: 20,
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        CategoryCard(
                          title: "Map",
                          jsonImage: "assets/images/map1.json",
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => MapScreen()));
                          },
                        ),
                        CategoryCard(
                          title: "Upload data",
                          jsonImage: "assets/images/upload.json",
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UploadScreen()));
                          },
                        ),
                        CategoryCard(
                          title: "Assistances",
                          jsonImage: "assets/images/contact.json",
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ContactScreen()));
                          },
                        ),
                        CategoryCard(
                          title: "History",
                          jsonImage: "assets/images/history.json",
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HistoryScreen()));
                          },
                        ),
                      ],
                    ),
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
                color: kPrimaryLightColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Lottie.asset("assets/images/banner.json",
                        height: 200, width: 200),
                  ],
                ),
              )),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     elevation: 0,
    //
    //     backgroundColor: Color(0xFF80D8FF),
    //     title: Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         Icon(Icons.location_on_outlined,color: Colors.white,),
    //         Text(' DaNang, VietNam', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
    //
    //       ],
    //     ),
    //     // leading: IconButton(
    //     //   icon: Icon(Icons.menu_open_outlined),
    //     //   onPressed: () {
    //     //   },
    //     // ),
    //     actions: [
    //       IconButton(
    //           icon: Image.asset("assets/images/bell.png", width: 24,),
    //           onPressed: () {
    //             // return Container(
    //             //   child: Scaffold(
    //             //     drawer: MainDrawer(),
    //             //   ),
    //             // );
    //           },
    //       ),
    //     ],
    //   ),
    //   body: ListView(children: [
    //     Container(
    //       width: MediaQuery.of(context).size.width,
    //       height: MediaQuery.of(context).size.height,
    //       decoration: BoxDecoration(
    //         color: Color(0xFF80D8FF),
    //       ),
    //       child: Column(
    //         children: [
    //           SizedBox(
    //             height: 200,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.end,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Lottie.asset("assets/images/banner.json", height: 200, width: 200),
    //               ],
    //             ),
    //           ),
    //           // Expanded(
    //           //   child: Container(
    //           //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    //           //     height: MediaQuery.of(context).size.height - 200,
    //           //     decoration: BoxDecoration(
    //           //       borderRadius: BorderRadius.circular(30),
    //           //       color: Colors.grey[200],
    //           //     ),
    //           //     child: Column(children: [
    //           //       mainCard(context),
    //           //       SizedBox(height: 20),
    //           //       Expanded(
    //           //         child: GridView.count(
    //           //           crossAxisSpacing: 20,
    //           //           crossAxisCount: 2,
    //           //           childAspectRatio: .94,
    //           //           mainAxisSpacing: 10,
    //           //           children: <Widget>[
    //           //             CategoryCard(
    //           //               title: "Map",
    //           //               jsonImage: "assets/images/map1.json",
    //           //               press: () {},
    //           //             ),
    //           //             CategoryCard(
    //           //               title: "About",
    //           //               jsonImage: "assets/images/about.json",
    //           //               press: () {},
    //           //             ),
    //           //             CategoryCard(
    //           //               title: "Contact",
    //           //               jsonImage: "assets/images/contact.json",
    //           //               press: () {},
    //           //             ),
    //           //             CategoryCard(
    //           //               title: "Upload data",
    //           //               jsonImage: "assets/images/upload.json",
    //           //               press: () {},
    //           //             ),
    //           //           ],
    //           //         ),
    //           //       ),
    //           //     ],),
    //           //   ),
    //           // ),
    //           Container(
    //             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
    //             height: MediaQuery.of(context).size.height - 200,
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(30),
    //               color: Colors.grey[200],
    //             ),
    //             child: Column(children: [
    //               mainCard(context),
    //               SizedBox(height: 40),
    //               Expanded(
    //                 child: GridView.count(
    //                   crossAxisSpacing: 20,
    //                   crossAxisCount: 2,
    //                   childAspectRatio: .94,
    //                   mainAxisSpacing: 10,
    //                   physics: NeverScrollableScrollPhysics(),
    //                   children: <Widget>[
    //                     CategoryCard(
    //                       title: "Map",
    //                       jsonImage: "assets/images/map1.json",
    //                       press: () {
    //                         Navigator.push(context, MaterialPageRoute(builder: (_) => MapScreen()));
    //                       },
    //                     ),
    //                     CategoryCard(
    //                       title: "Upload data",
    //                       jsonImage: "assets/images/upload.json",
    //                       press: () {
    //                         Navigator.push(context, MaterialPageRoute(builder: (_) => UploadScreen()));
    //                       },
    //                     ),
    //                     CategoryCard(
    //                       title: "Assistances",
    //                       jsonImage: "assets/images/contact.json",
    //                       press: () {
    //                         Navigator.push(context, MaterialPageRoute(builder: (_) => ContactScreen()));
    //                       },
    //                     ),
    //
    //                     CategoryCard(
    //                       title: "About",
    //                       jsonImage: "assets/images/about.json",
    //                       press: () {
    //                         Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
    //                       },
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ],),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],),
    // );
  }
}
Container mainCard(context) {
  return Container(
    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: kPrimaryColor,
          offset: Offset.zero,
          blurRadius: 20,
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          width: (MediaQuery.of(context).size.width - 80) / 2,
          height: 140,
          child: Lottie.asset("assets/images/upload.json",
              height: 200, width: 200),
        ),
        SizedBox(
          width: (MediaQuery.of(context).size.width - 80) / 2,
          height: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assistance driver',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Assist the driver safely on bad roads',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
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

TextStyle textStyle(double size, FontWeight fontWeight, Color colorName) =>
    TextStyle(
      fontFamily: 'Quicksand',
      color: colorName,
      fontSize: size,
      fontWeight: fontWeight,
    );
