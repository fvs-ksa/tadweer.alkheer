import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tadweer_alkheer/screens/tabs_screen.dart';

class RatingDoneScreen extends StatelessWidget {
  const RatingDoneScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Image.asset(
                    'assets/images/correct_picture.png',
                    width: 100,
                    height: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Text(
                      AppLocalizations.of(context).ratingDone,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 0.6, 5.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),

                          // <-- Radius
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    TabsScreen(0)));
                      },
                      child: Text(
                        AppLocalizations.of(context).returnToHome,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
