// map page + i have a thing to add here which is #111.
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/place_location.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen(
      {this.initialLocation =
          const PlaceLocation(latitude: 37.422, longitude: -122.084),
      this.isSelecting = false});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 4),
          content: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
              ),
              children: [
                TextSpan(text: AppLocalizations.of(context).clickon),
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Icon(
                      Icons.place,
                      color: Colors.red,
                    ),
                  ),
                ),
                TextSpan(text: AppLocalizations.of(context).tonavigate),
              ],
            ),
          ),
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).mapLocation),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: (Icon(Icons.check)),
              onPressed: _pickedLocation == null
                  ? null
                  : () {
                      Navigator.of(context).pop(_pickedLocation);
                    },
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 16,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (_pickedLocation == null && widget.isSelecting == true)
            ? Set<Marker>()
            : Set<Marker>().add(Marker(
          markerId: MarkerId('m1'),
          position: _pickedLocation ??
              LatLng(
                widget.initialLocation.latitude,
                widget.initialLocation.longitude,
              ),
        ))
      ),
    );
  }
}
