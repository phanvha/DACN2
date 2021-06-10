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
      borderRadius: BorderRadius.circular(5),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(85),
          // boxShadow: [
          //   BoxShadow(
          //     color: kPrimaryColor,
          //     offset: Offset(0.0, 3.0), //(x,y)
          //     blurRadius: 6.0,
          //   ),
          //],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Lottie.asset(jsonImage, height: 100, width: 100),
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