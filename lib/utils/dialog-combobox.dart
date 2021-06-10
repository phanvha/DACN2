import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text;
  final Image img;
  final VoidCallback callback;

  const CustomDialogBox(
      {Key key, this.title, this.descriptions, this.text, this.img, this.callback})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return widget.text != null ||
            widget.title != null ||
            widget.descriptions != null
        ? Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.padding),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: contentBox(context),
          )
        : Container(
            width: 100,
            height: 100,
            //margin: EdgeInsets.all(100),
            decoration: BoxDecoration(
              // shape: BoxShape.rectangle,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(Constants.padding),
              // boxShadow: [
              //   BoxShadow(color: Colors.black,offset: Offset(0,8),
              //       blurRadius: 6
              //   ),
              // ]
            ),
            child: Center(
              child: Lottie.asset("assets/images/success.json",
                  width: 100, height: 100, repeat: false),
            ));
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 8), blurRadius: 6),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                    onPressed: () {
                      widget.callback.call();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CustomDialogBox()));
                    },
                    child: Text(
                      widget.text,
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Lottie.asset("assets/images/alert-loop.json")),
          ),
        ),
      ],
    );
  }

  startTime() async {
    if (widget.text != null ||
        widget.title != null ||
        widget.descriptions != null) {
      var _duration = new Duration(seconds: 5);
      return new Timer(_duration, navigationPage);
    } else {
      var _duration = new Duration(seconds: 3);
      return new Timer(_duration, navigationPage);
    }
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    startTime();
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}
