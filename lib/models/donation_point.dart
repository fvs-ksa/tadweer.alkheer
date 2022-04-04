import 'package:cloud_firestore/cloud_firestore.dart';

class DonationPoint {
  final String name;
  final GeoPoint location;

  DonationPoint.fromMap(Map snapshot)
      : name = snapshot['name'] ?? '',
        location = snapshot['location'] ?? '';
}
