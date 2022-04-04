import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tadweer_alkheer/screens/aboutus_screen.dart';
import 'package:tadweer_alkheer/screens/alwalaa_screen.dart';
import 'package:tadweer_alkheer/screens/image_gallery_screen.dart';
import 'package:tadweer_alkheer/screens/rating_app.dart';
import 'package:tadweer_alkheer/screens/support_center.dart';
import 'package:tadweer_alkheer/widgets/rating_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import './settings_screen.dart';
import 'package:tadweer_alkheer/screens/spp_screen.dart';
import 'points_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:launch_review/launch_review.dart';

class Morescreen extends StatefulWidget {
  @override
  State<Morescreen> createState() => _MorescreenState();
}

class _MorescreenState extends State<Morescreen> {
  _ourAppUrl() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.tadweer.alkheer';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _ourWebsiteUrl() async {
    const url = 'http://tadwer-khir.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              // settings
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: Colors.green[100],
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen())),
                    child: Text(AppLocalizations.of(context).settings)),
              ),
              Divider(),
              // about us
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                    color: Colors.green[100],
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AboutUsScreen())),
                    child: Text(AppLocalizations.of(context).aboutus)),
              ),
              Divider(),
              // map
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: Colors.green[100],
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PointsMapScreen())),
                    child: Text(AppLocalizations.of(context).markedPoint)),
              ),
              Divider(),
              // photo gallery
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: Colors.green[100],
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageGalleryScreen())),
                    child: Text(AppLocalizations.of(context).imageGallery)),
              ),
              Divider(),
              //website
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: Colors.green[100],
                    onPressed: _ourWebsiteUrl,
                    child: Text(AppLocalizations.of(context).ourWebsite)),
              ),
              Divider(),
              // contact us
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: Colors.green[100],
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SupportCenter())),
                    child: Text(AppLocalizations.of(context).supportcenter)),
              ),
              Divider(),
              // Rate the app
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: Colors.green[100],
                    onPressed: _ourAppUrl,
                    /*() {
                      LaunchReview.launch(
                        androidAppId: 'com.example.tadweer_alkheer',
                        iOSAppId: 'com.tadweer.alkher',
                      );
                    },
                    */

                    child: Text(AppLocalizations.of(context).rateText)),
              ),
              Divider(),
              // alwalaa program
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: Colors.green[100],
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => points())),
                    child:
                        Text(AppLocalizations.of(context).contributionpoints)),
              ),
              Divider(),
              /*
              Container(
                width: 360,
                height: 70,
                child: ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => )),
                    child: Text("nome")),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}


/*
Card(
                child: Container(
                  width: double.infinity,
                  height: 70,
                  child: RaisedButton(
                      color: Colors.green[100],
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutUsScreen())),
                      child: Text(AppLocalizations.of(context).aboutus)),
                ),
              ),
*/