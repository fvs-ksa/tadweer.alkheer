import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:tadweer_alkheer/main.dart';
import 'package:tadweer_alkheer/screens/home_screen.dart';

class ssp extends StatefulWidget {
  @override
  _sspState createState() => _sspState();
}

class _sspState extends State<ssp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
            duration: 5000,
            splash: Lottie.network(
                'https://assets3.lottiefiles.com/packages/lf20_mmx4p1bl.json'),
            splashIconSize: 1000,
            nextScreen: MainScreen(),
            splashTransition: SplashTransition.decoratedBoxTransition,
            backgroundColor: Colors.white));
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
            child: Container(
          child: Text("Hello World "),
        )),
      ),
    );
  }
}
