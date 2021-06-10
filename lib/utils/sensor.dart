import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';
import 'package:shake/shake.dart';


ShakeDetector getShake(){
  ShakeDetector detector = ShakeDetector.waitForStart(
      onPhoneShake: () {
        // Do stuff on phone shake
        print("Shaking...");
      }
  );
  detector.startListening();
  return detector;
}
