import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class points extends StatefulWidget {
  @override
  _pointsState createState() => _pointsState();
}

class _pointsState extends State<points> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).mydonationPoint),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(20),
        child: Column(children: <Widget>[
          Container(
            padding: EdgeInsets.all(15),
            child: Image.asset('assets/images/splash_1.png'),
          ),
          Text(
            AppLocalizations.of(context).definePoints,
          ),
        ]),
      ),
      /*
          Text(AppLocalizations.of(context).walaaProgram),
          Text(
            AppLocalizations.of(context).titleLogo,
            style: TextStyle(
              decorationStyle: TextDecorationStyle.dashed,
              fontWeight: FontWeight.bold,
            ),
          )*/
    );
  }
}
