//map location on the donation details page.
import 'package:flutter/material.dart';
import '../services/location_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationView extends StatefulWidget {
  final double lat;
  final double lng;

  LocationView(this.lat, this.lng);
  @override
  _LocationViewState createState() {
    return _LocationViewState();
  }
}

class _LocationViewState extends State<LocationView> {
  String _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  @override
  void initState() {
    super.initState();

    _showPreview(widget.lat, widget.lng);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 170,
          width: double.infinity,
          decoration:
              BoxDecoration(border: Border.all(width: 2, color: Colors.green)),
          child: _previewImageUrl == null
              ? Text(
                  AppLocalizations.of(context).noLocationChosen,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green[700]),
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
          alignment: Alignment.center,
        ),
      ],
    );
  }
}
