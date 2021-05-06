import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:Poro/constant.dart';

class CategoryCard extends StatelessWidget {
  final String jsonImage;
  final String title;
  final Function press;
  const CategoryCard({
    Key key,
    this.jsonImage,
    this.title,
    this.press,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ClipRRect(
      borderRadius: BorderRadius.circular(13),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 17),
              blurRadius: 20,
              spreadRadius: -23,
              color: kShadowColor,
            ),
          ]
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Lottie.asset(jsonImage, height: 90, width: 90),
                  Spacer(),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.title.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}