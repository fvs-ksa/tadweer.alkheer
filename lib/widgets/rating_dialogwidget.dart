import 'package:flutter/material.dart';
import 'package:rating_dialog/rating_dialog.dart';

void _showRatingAppDialog() {
  final _ratingDialog = RatingDialog(
    starColor: Colors.green,
    title: Text('Rating Dialog In Flutter'),
    message: Text('Rating this app and tell others what you think.'
        ' Add more description here if you want.'),
    image: Image.asset(
      "assets/images/devs.jpg",
      height: 100,
    ),
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
    barrierDismissible: true,
    builder: (context) => _ratingDialog,
    context: null,
  );
}
