import 'package:flutter/material.dart';
import 'donation_details_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RatingDialog extends StatefulWidget {
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _stars = 0;

  Widget _buildStar(int starCount) {
    return InkWell(
      child: Icon(
        Icons.star,
        // size: 30.0,
        color: _stars >= starCount ? Colors.green : Colors.grey,
      ),
      onTap: () {
        setState(() {
          _stars = starCount;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(AppLocalizations.of(context).rateText),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildStar(1),
          _buildStar(2),
          _buildStar(3),
          _buildStar(4),
          _buildStar(5),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(AppLocalizations.of(context).cancel),
          onPressed: () {
            Navigator.of(context).pop(DonationDetailsScreen);
          },
        ),
        FlatButton(
          child: Text(AppLocalizations.of(context).save),
          onPressed: () {
            Navigator.of(context).pop(DonationDetailsScreen);
          },
        )
      ],
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';

class DemoScreen extends StatefulWidget {
  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Rating Dialog In Flutter'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Center(
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            color: Colors.cyan,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Text(
              'Rating Dialog',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onPressed: _showRatingAppDialog,
          ),
        ),
      ),
    );
  }

  void _showRatingAppDialog() {
    final _ratingDialog = RatingDialog(
      starColor: Colors.amber,
      title: Text('Rating Dialog In Flutter'),
      message: Text('Rating this app and tell others what you think.'
          ' Add more description here if you want.'),
      submitButtonText: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, '
            'comment: ${response.comment}');

        if (response.rating < 3.0) {
          print('response.rating: ${response.rating}');
        } else {
          Container();
        }
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _ratingDialog,
    );
  }
}
*/


