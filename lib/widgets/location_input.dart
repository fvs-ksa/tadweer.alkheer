//map location on the donation page.
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/location_helper.dart';
import '../screens/map_screen.dart';
import '../models/place_location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;

  LocationInput(this.onSelectPlace);
  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);

    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      print(locData.latitude);
      print(locData.longitude);
      _showPreview(locData.latitude, locData.longitude);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      return;
    }
  }

  Future<void> _selectOnMap() async {
    final locData = await Location().getLocation();

    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
            isSelecting: true,
            initialLocation: PlaceLocation(
              longitude: locData.longitude,
              latitude: locData.latitude,
            )),
      ),
    );

    if (selectedLocation == null) {
      return;
    }
    print('latitude: ${selectedLocation.latitude}');
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);

    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text(AppLocalizations.of(context).currentLocation),
              textColor: Theme.of(context).primaryColor,
              onPressed: _getCurrentUserLocation,
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text(AppLocalizations.of(context).selectOnMap),
              textColor: Theme.of(context).primaryColor,
              onPressed: _selectOnMap,
            )
          ],
        )
      ],
    );
  }
}
