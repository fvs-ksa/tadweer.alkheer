import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:store_redirect/store_redirect.dart';

class RatingApp extends StatefulWidget {
  @override
  _RatingAppState createState() => _RatingAppState();
}

class _RatingAppState extends State<RatingApp> {
  final _dialog = RatingDialog(
    // your app's name?
    title: Text('Rate Us On App Store'),
    // encourage your user to leave a high rating?
    message: Text('Select Number of Stars 1 - 5 to Rate This App'),
    // your app's logo?
    image: Image.asset('assets/images/splash_logo.png'),
    submitButtonText: 'Submit',
    onCancelled: () => print('cancelled'),
    onSubmitted: (response) {
      print('rating: ${response.rating}, comment: ${response.comment}');

      // ignore: todo
      // TODO: add your own logic
      if (response.rating < 3.0) {
        // send their comments to your email or anywhere you wish
        // ask the user to contact you instead of leaving a bad review
      } else {
        //go to app store
        StoreRedirect.redirect(
            androidAppId: 'com.example.tadweer_alkheer',
            iOSAppId: 'com.tadweer.alkher');
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FlatButton(
          child: Text(AppLocalizations.of(context).rateText),
          onPressed: () {
            RatingApp();
          },
        ),
      ),
    );
  }
}
