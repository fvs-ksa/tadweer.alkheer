import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tadweer_alkheer/models/donation_point.dart';
import 'package:tadweer_alkheer/providers/donation_points_provider.dart';

class PointsMapScreen extends StatefulWidget {
  @override
  _PointsMapScreen createState() => _PointsMapScreen();
}

class _PointsMapScreen extends State<PointsMapScreen> {
  String mapStyle= '''
    [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
]''';
  static const LatLng JeddahCity = const LatLng(
      21.522183756678935, 39.183047656138825); //location to show in map

  GoogleMapController mapController; //contrller for Google map
  List<DonationPoint> points;

  @override
  Widget build(BuildContext context) {

    final pointsProvider = Provider.of<TODonationPointsProvider>(context);

    return FutureBuilder(
      future: pointsProvider.fetchPoints(),
      builder: (ctx, pointsSnapshot) {
        if (pointsSnapshot.connectionState ==
            ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        points = pointsSnapshot.data;

        return Scaffold(
          body: GoogleMap(
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true,
            //enable Zoom in, out on map
            initialCameraPosition: CameraPosition(
              //inital position in map
              target: JeddahCity, //initial position
              zoom: 14.0, //initial zoom level
            ),
            markers: getMarkers(),
            //markers to show on map
            mapType: MapType.normal, //map type
            onMapCreated: (controller) {
              controller.setMapStyle(mapStyle);
              //method called when map is created
              controller.animateCamera(CameraUpdate.newLatLngBounds(getLatLngBounds(points), 10.0));
            },
          ),
        );
      }

    );
  }

  Set<Marker> getMarkers() {

    final Set<Marker> markers = new Set(); //markers for google map

    if(points != null) {
      for(var i = 0; i < points.length; i++){
        var point = points[i];

        markers.add(Marker(
          markerId: MarkerId('$i'),
          position: LatLng(point.location.latitude, point.location.longitude), //position of marker
          infoWindow: InfoWindow(
            //popup info
            title: points[i].name,
          ),
          icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        ));
      }

    }
    return markers;
  }

  static LatLngBounds getLatLngBounds(List<DonationPoint> list) {
    double x0, x1, y0, y1;
    for (final point in list) {
      if (x0 == null) {
        x0 = x1 = point.location.latitude;
        y0 = y1 = point.location.longitude;
      } else {
        if (point.location.latitude > x1) x1 = point.location.latitude;
        if (point.location.latitude < x0) x0 = point.location.latitude;
        if (point.location.longitude > y1) y1 = point.location.longitude;
        if (point.location.longitude < y0) y0 = point.location.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

}
