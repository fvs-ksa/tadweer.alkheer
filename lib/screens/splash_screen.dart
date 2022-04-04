//The splash screen

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/ColorizeAnimatedText.dart';
import 'package:splash_screen_view/ScaleAnimatedText.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:splash_screen_view/TyperAnimatedText.dart';

import '../main.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenView(
        navigateRoute: MainScreen(),
        duration: 3500,
        imageSize: MediaQuery.of(context).size.height.toInt() - 25,
        imageSrc: "assets/images/Comp2(1).gif",
        backgroundColor: Colors.white,
      ),
    );
  }
}
