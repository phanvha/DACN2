import 'package:Poro/Screens/History/history-screen.dart';
import 'package:Poro/Screens/Home/About/About_detail.dart';
import 'package:Poro/Screens/Home/Contact/Contact_detail.dart';
import 'package:Poro/Screens/Home/Map/Map_detail.dart';
import 'package:Poro/Screens/Home/Upload/Upload_detail.dart';
import 'package:Poro/Screens/Home/Widgets/CardView.dart';
import 'package:Poro/Screens/Home/Widgets/category_card.dart';
import 'package:Poro/Screens/SideBar/Sidebar_screen.dart';
import 'package:Poro/constant.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
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
    FlutterStatusbarcolor.setStatusBarColor(Colors.blueGrey[400]);

    // TODO: implement build
    return Container(
      // color: kPrimaryColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          primary: true,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageSlideshow(
                width: double.infinity,
                height: size.height*0.45,
                initialPage: 0,
                indicatorColor: Colors.blue,
                indicatorBackgroundColor: Colors.grey,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      image: DecorationImage(
                          image: NetworkImage(
                            'https://cdn.baogiaothong.vn/files/f1/2014/12/11/viet-nam-tang-16-bac-xep-hang-ha-tang-giao-thong.jpg',
                          ),
                          fit: BoxFit.cover
                      )
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(.6),
                                Colors.black.withOpacity(.1)
                              ]),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
                              child: Text(
                                "Báo Giao Thông Việt Nam tăng 16 bậc xếp hạng hạ tầng giao thông",
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )),

                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        image: DecorationImage(
                            image: NetworkImage(
                              'https://i1-vnexpress.vnecdn.net/2020/06/18/nut-giao-thong-my-thuy-7287-1592456341.jpg?w=680&h=0&q=100&dpr=1&fit=crop&s=EJwtxj-1YouOU3a8i_MuTg',
                            ),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(.6),
                                Colors.black.withOpacity(.1)
                              ]),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
                              child: Text(
                                "Giao thông Sài Gòn thiếu kinh phí",
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )),

                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        image: DecorationImage(
                            image: NetworkImage(
                              'https://i1-vnexpress.vnecdn.net/2021/05/19/cao-toc-moc-bai-4175-161285953-4934-1478-1621419521.jpg?w=680&h=0&q=100&dpr=1&fit=crop&s=DfFFB_a5oBmJRDzHE6L1gQ',
                            ),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(.6),
                                Colors.black.withOpacity(.1)
                              ]),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
                              child: Text(
                                "Cao tốc TP HCM - Mộc Bài tăng vốn gần 2.300 tỷ đồng",
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )),

                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        image: DecorationImage(
                            image: NetworkImage(
                              'https://i1-vnexpress.vnecdn.net/2021/05/18/do-hoa-tuyen-tren-cao-2158-1621336820.png?w=680&h=0&q=100&dpr=1&fit=crop&s=5gSvS5-LXiopHFKPV3UqWw',
                            ),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(.6),
                                Colors.black.withOpacity(.1)
                              ]),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
                              child: Text(
                                "Đề xuất 30.000 tỷ đồng làm đường trên cao ở TP HCM",
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )),

                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        image: DecorationImage(
                            image: NetworkImage(
                              'https://i1-vnexpress.vnecdn.net/2021/05/18/mo-hinh-cau-rach-mieu-2-160031-7452-6748-1621318382.jpg?w=680&h=0&q=100&dpr=1&fit=crop&s=qWPi4Bp9VL1nuURhmSZhOA',
                            ),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(.6),
                                Colors.black.withOpacity(.1)
                              ]),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
                              child: Text(
                                "Cầu Rạch Miễu 2 sẽ khởi công cuối năm nay",
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )),

                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        image: DecorationImage(
                            image: NetworkImage(
                              'https://i1-vnexpress.vnecdn.net/2021/05/13/12-1-jpeg-7349-1620908185.jpg?w=680&h=0&q=100&dpr=1&fit=crop&s=XrnogM7fe2ZRhpJK2MBlRw',
                            ),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(.6),
                                Colors.black.withOpacity(.1)
                              ]),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
                              child: Text(
                                "Hơn 2.200 tỷ đồng sửa chữa quốc lộ về miền Tây",
                                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        )),

                  ),

                ],
                onPageChanged: (value) {
                  print('Page changed: $value');
                },
                autoPlayInterval: 10000,
              ),

              Container(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: Colors.white
                      ),
                      child: Column(
                        children: [
                          GridView.count(
                            crossAxisSpacing: 10,
                            crossAxisCount: 2,
                            childAspectRatio: 1,
                            mainAxisSpacing: 5,
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

            ],
          ),
        )
        // child: Scaffold(
        //   primary: true,
        //   appBar: PreferredSize(
        //     preferredSize: Size.fromHeight(kToolbarHeight),
        //     child: AnimatedContainer(
        //         height: _isAppbar ? 80.0 : 0.0,
        //         duration: Duration(milliseconds: 200),
        //         child: AppBar(
        //           elevation: 0,
        //           backgroundColor: Color(0xFF80D8FF),
        //           title: Row(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             children: [
        //               Icon(
        //                 Icons.location_on_outlined,
        //                 color: Colors.white,
        //               ),
        //               Text(' DaNang, VietNam',
        //                   style: TextStyle(
        //                       fontSize: 18,
        //                       fontWeight: FontWeight.w800,
        //                       color: Colors.white)),
        //             ],
        //           ),
        //           actions: [
        //             IconButton(
        //               icon: Image.asset(
        //                 "assets/images/bell.png",
        //                 width: 24,
        //               ),
        //               onPressed: () {
        //                 // return Container(
        //                 //   child: Scaffold(
        //                 //     drawer: MainDrawer(),
        //                 //   ),
        //                 // );
        //               },
        //             ),
        //           ],
        //         )),
        //   ),
        //   body: SlidingUpPanel(
        //       controller: _panelController,
        //       minHeight: size.height / 1.8,
        //       maxHeight: size.height / 1.5,
        //       borderRadius: BorderRadius.circular(0),
        //       onPanelClosed: () {
        //         appBarStatus(true);
        //       },
        //       onPanelOpened: () {
        //         appBarStatus(false);
        //       },
        //       panel: Container(
        //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        //         height: MediaQuery.of(context).size.height,
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(0),
        //           color: kPrimaryColor.withOpacity(.8),
        //         ),
        //         child: Column(
        //           children: [
        //             mainCard(context),
        //             SizedBox(height: 20),
        //             GridView.count(
        //               crossAxisSpacing: 20,
        //               crossAxisCount: 2,
        //               childAspectRatio: 1,
        //               mainAxisSpacing: 10,
        //               shrinkWrap: true,
        //               physics: NeverScrollableScrollPhysics(),
        //               children: <Widget>[
        //                 CategoryCard(
        //                   title: "Map",
        //                   jsonImage: "assets/images/map1.json",
        //                   press: () {
        //                     Navigator.push(
        //                         context,
        //                         MaterialPageRoute(
        //                             builder: (_) => MapScreen()));
        //                   },
        //                 ),
        //                 CategoryCard(
        //                   title: "Upload data",
        //                   jsonImage: "assets/images/upload.json",
        //                   press: () {
        //                     Navigator.push(
        //                         context,
        //                         MaterialPageRoute(
        //                             builder: (_) => UploadScreen()));
        //                   },
        //                 ),
        //                 CategoryCard(
        //                   title: "Assistances",
        //                   jsonImage: "assets/images/contact.json",
        //                   press: () {
        //                     Navigator.push(
        //                         context,
        //                         MaterialPageRoute(
        //                             builder: (_) => ContactScreen()));
        //                   },
        //                 ),
        //                 CategoryCard(
        //                   title: "History",
        //                   jsonImage: "assets/images/history.json",
        //                   press: () {
        //                     Navigator.push(
        //                         context,
        //                         MaterialPageRoute(
        //                             builder: (_) => HistoryScreen()));
        //                   },
        //                 ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       ),
        //       // collapsed: Container(
        //       //   decoration:
        //       //       BoxDecoration(color: kPrimaryColor, borderRadius: radius),
        //       //   child: InkWell(
        //       //     onTap: () {
        //       //       _panelController.open();
        //       //     },
        //       //     child: Ink(
        //       //       child: Column(
        //       //         children: [
        //       //           // buildDragIcon(Colors.white),
        //       //           Container(
        //       //             child: Text(
        //       //               "More",
        //       //               style: TextStyle(
        //       //                 color: Colors.white,
        //       //               ),
        //       //             ),
        //       //           ),
        //       //         ],
        //       //       ),
        //       //     ),
        //       //   ),
        //       // ),
        //       body: Container(
        //         color: kPrimaryLightColor,
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           children: [
        //             Lottie.asset("assets/images/banner.json",
        //                 height: 200, width: 200),
        //           ],
        //         ),
        //       )),
        // ),
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
