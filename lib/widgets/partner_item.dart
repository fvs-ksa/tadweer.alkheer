import 'package:flutter/material.dart';
import 'package:tadweer_alkheer/models/partner.dart';

class PartnerItem extends StatefulWidget {
  final Partner _partner;

  PartnerItem(this._partner);

  @override
  _PartnerItemState createState() => _PartnerItemState();
}

class _PartnerItemState extends State<PartnerItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      //added this video.
      child: Container(
        padding: EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height * 0.23,
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            FadeInImage(
              width:  400,
              height: 100,
              //placeholder appears for afew minutes while the image loads
              placeholder: AssetImage(
                  'assets/images/placeholder.png'),
              image: NetworkImage(widget._partner.image),

              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/images/placeholder.png",
                  height: 260,
                  width: 260,
                );
              },
              fit: BoxFit.contain,
            ),

            SizedBox(height: 20),

            Flexible(
              child: Text(widget._partner.description,
                overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
    );
  }
}
