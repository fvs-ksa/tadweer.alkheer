import 'package:flutter/material.dart';
import 'package:tadweer_alkheer/models/donation.dart';
import 'package:tadweer_alkheer/screens/donation_details_screen.dart';

class DonationItem extends StatefulWidget {
  final Donation donation;

  DonationItem(this.donation);
  @override
  _DonationItemState createState() => _DonationItemState();
}

class _DonationItemState extends State<DonationItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => DonationDetailsScreen(widget.donation),
        ));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 0.5, color: Colors.grey)),
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.12,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.donation.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(widget.donation.description)
            ],
          ),
        ),
      ),
    );
  }
}
