import 'package:Poro/Screens/Login/Login_screen.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:Poro/constant.dart';
import 'package:lottie/lottie.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
    // TODO: implement createState
}
class _LoadingPageState extends State<LoadingPage> {
  List<Slide> slides = new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slides.add(
      new Slide(
        title: "Select Location",
        description: "Allow the user to quickly search for the desired location",
        pathImage: "assets/images/searchengine.jpg"
      ),
    );
    slides.add(
      new Slide(
          title: "Alert bad road",
          description: "Warning spots with bad roads on the way you go",
          pathImage: "assets/images/pothole.png"
      ),
    );
    slides.add(
      new Slide(
          title: "Easy navigation",
          description: "Navigation your way to the desired location on the map with easy",
          pathImage: "assets/images/map.png"
      ),
    );
  }
  List<Widget> renderListCustomTabs() {
    List<Widget> tabs = new List();
    for (int i = 0; i < slides.length; i++){
      Slide currentSlide = slides[i];
      tabs.add(
        Container(
          width: double.infinity,
          height: double.infinity,
          child: Container(
            margin: EdgeInsets.only(bottom: 160, top: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: BackgroundColor,
                  ),
                  child: Image.asset(
                    currentSlide.pathImage,
                    matchTextDirection: true,
                    height: 240,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    currentSlide.title,
                    style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30,),
                  child: Text(
                    currentSlide.description,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 17,
                      height: 1.5,
                      // fontStyle: FontStyle.italic,
                      fontFamily: 'RobotoMono',
                    ),
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  margin: EdgeInsets.only(
                    top: 15,
                    left: 20,
                    right: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return tabs;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IntroSlider(
      backgroundColorAllSlides: BackgroundColor,
      renderSkipBtn: Text(
          "Skip",
        style: TextStyle(
          fontFamily: 'RobotoMono',
          fontSize: 16,
        ),
      ),
      renderNextBtn: Text(
        "NEXT",
        style: TextStyle(color: Colors.black, fontFamily: 'RobotoMono'),
      ),
      renderDoneBtn: Text(
        "Login",
        style: TextStyle(color: Colors.black),
      ),
      colorDoneBtn: Colors.white,
      colorActiveDot: Colors.white,
      sizeDot: 8.0,
      typeDotAnimation: dotSliderAnimation.SIZE_TRANSITION,
      listCustomTabs: this.renderListCustomTabs(),
      scrollPhysics: BouncingScrollPhysics(),
      shouldHideStatusBar: false,
      onDonePress: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen(),
          ),
      ),
    );
  }
}