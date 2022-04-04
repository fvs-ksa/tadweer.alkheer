// ignore_for_file: missing_required_param

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tadweer_alkheer/models/points.dart';
import 'package:tadweer_alkheer/screens/rating_Dialog.dart';
import 'package:tadweer_alkheer/screens/rating_done_screen.dart';
import 'package:tadweer_alkheer/widgets/location_View.dart';
import 'package:tadweer_alkheer/models/donation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tadweer_alkheer/providers/locale_provider.dart';
import 'package:tadweer_alkheer/widgets/progressBar.dart';

import '../providers/donation_points_provider.dart';
import 'donation_done_screen.dart';

class DonationDetailsScreen extends StatefulWidget {
  final Donation donation;
  DonationDetailsScreen(this.donation);

  @override
  State<DonationDetailsScreen> createState() => _DonationDetailsScreenState();
}

class _DonationDetailsScreenState extends State<DonationDetailsScreen> {
  double rate = 1;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final currentLocale = localeProvider.locale;

    var donationStatusText = widget.donation.status;
    if (currentLocale.languageCode == 'ar') {
      donationStatusText = "في انتظار الاستلام";
    }

    DataColumn pickupDateCol = DataColumn(
        label: Text(
      AppLocalizations.of(context).pickupDate,
      style: TextStyle(color: Colors.white),
    ));
    DataColumn dividerCol = DataColumn(
        label: VerticalDivider(
      width: 3,
      color: Colors.black,
    ));
    DataColumn pickupTimeCol = DataColumn(
        label: Text(AppLocalizations.of(context).pickupTime,
            style: TextStyle(color: Colors.white)));

    DataCell pickupDateCell = DataCell(Text(
      DateFormat('dd/MM/yyyy')
          .format(widget.donation.pickupDateTime)
          .toString(),
    ));
    DataCell pickupTimeCell = DataCell(Text(
      DateFormat('HH:mm').format(widget.donation.pickupDateTime).toString(),
    ));

    DataRow tableRow = DataRow(cells: [
      pickupDateCell,
      DataCell(VerticalDivider(
        width: 3,
        color: Colors.black,
      )),
      pickupTimeCell
    ]);
    int rating = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          AppLocalizations.of(context).mydonations,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 26),
            // First Text (Order Number.)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${AppLocalizations.of(context).order} #${widget.donation.id}",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold),
              ),
            ),

            /*
            SizedBox(height: 8),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context).quantity,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        widget.donation.quantity.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context).posteddate,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(widget.donation.date)
                            .toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              "${AppLocalizations.of(context).itemdescription} ${widget.donation.description}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 18),
            Divider(
              color: Colors.grey,
              height: 2,
            ),
            SizedBox(height: 18),
            //TODO: Here Will add the DataTable.
            DataTable(
                dataRowHeight: 26,
                headingRowHeight: 26,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12, width: 1),
                    borderRadius: BorderRadius.circular(10.0)),
                headingRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.green),
                columns: [pickupDateCol, dividerCol, pickupTimeCol],
                rows: [tableRow]),
      
            SizedBox(height: 18),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageView(widget.donation.imageUrl),
                VideoView(widget.donation.videoUrl),
              ],
            ),
            */
            //The Text below will be changed to Map Containaer.
            Container(
              width: MediaQuery.of(context).size.width / 1.2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 18, 10, 0),
                child: LocationView(widget.donation.location.latitude,
                    widget.donation.location.longitude),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 22),
              child: ProgressBar(),
            ),
            Column(
              children: [
                Text(AppLocalizations.of(context).rateText),
              ],
            ),
            //rating button...

             Column(
              children: [
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.green,
                  ),
                  onRatingUpdate: (rating) {
                   rate = rating;
                  },
                ),
                TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).rateText),
                  maxLines: 2,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.multiline,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FlatButton(
                        onPressed: () {
                          final pointsProvider =
                          Provider.of<DonationPointsProvider>(context, listen: false);
                          pointsProvider.addPoints(Point(userId: FirebaseAuth.instance.currentUser.uid,quantity: 50,date: DateTime.now(),donationId: widget.donation.id));

                          final ratingProvider =
                          Provider.of<RatingProvider>(context, listen: false);
                          ratingProvider.addRating(Rating(userId: FirebaseAuth.instance.currentUser.uid,rate: rate,date: DateTime.now(),donationId: widget.donation.id,message: controller.text));
                          Navigator.of(context).pop();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => RatingDoneScreen()));
                        },
                        child: Text(AppLocalizations.of(context).sendComment)),
                  ],
                )
              ],
            ),

            Padding(padding: EdgeInsets.symmetric(vertical: 20)),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 8),
              decoration:
                  BoxDecoration(shape: BoxShape.rectangle, color: Colors.green),
              child: Text(
                donationStatusText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
