import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

SizedBox regularCard(String iconName, String cardLabel) {
  return SizedBox(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                offset: Offset.zero,
                blurRadius: 20,
              ),
            ],
          ),
          child: SvgPicture.asset(iconName, width: 30),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          cardLabel,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}

Container mainCard(context) {
  return Container(
    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey[300],
          offset: Offset.zero,
          blurRadius: 20,
        ),
      ],
    ),
  child: Row(children: [
      Container(
        alignment: Alignment.bottomCenter,
        width: (MediaQuery.of(context).size.width - 80) / 2,
        height: 140,
        child: Lottie.asset("assets/images/systemhelp.json", height: 200, width: 200),
      ),
    SizedBox(
      width: (MediaQuery.of(context).size.width - 80) / 2,
      height: 150,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Assistance driver',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 16),
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
    ],),
  );
}

TextStyle textStyle(double size, FontWeight fontWeight, Color colorName) => TextStyle(
  fontFamily: 'Quicksand',
  color: colorName,
  fontSize: size,
  fontWeight: fontWeight,
);