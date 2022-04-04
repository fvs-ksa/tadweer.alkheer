import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tadweer_alkheer/models/donation_point.dart';
import '../locator.dart';
import '../models/points.dart';
import '../services/crud_model.dart';

class DonationPointsProvider with ChangeNotifier {
  CRUDModel _crudeModel = locator<CRUDModel>();

  List<Point> points;

  DonationPointsProvider() {
    _crudeModel.setpath('donationPoints');
  }

  Future<List<Point>> fetchPoints() async {
    var result = await _crudeModel.ref.where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid).get();

    points = result.docs
        .map((doc) => Point.fromMap(doc.data(),doc.id))
        .toList();

    return points;
  }
  Future addPoints(Point data) async {
    var result = await _crudeModel.addDocument(data.toJson());
    print('points added: ' + result.id);

    return;
  }
}
class TODonationPointsProvider with ChangeNotifier {
  CRUDModel _crudeModel = locator<CRUDModel>();

  List<DonationPoint> points;

  TODonationPointsProvider() {
    _crudeModel.setpath('points');
  }

  Future<List<DonationPoint>> fetchPoints() async {
    var result = await _crudeModel.ref.where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid).get();

    points = result.docs
        .map((doc) => DonationPoint.fromMap(doc.data()))
        .toList();

    return points;
  }

}

class RatingProvider with ChangeNotifier {
  CRUDModel _crudeModel = locator<CRUDModel>();

  List<Rating> ratings;

  RatingProvider() {
    _crudeModel.setpath('ratings');
  }

  Future<List<Rating>> fetchPoints() async {
    var result = await _crudeModel.ref.where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid).get();

    ratings = result.docs
        .map((doc) => Rating.fromMap(doc.data(),doc.id))
        .toList();

    return ratings;
  }
  Future addRating(Rating data) async {
    var result = await _crudeModel.addDocument(data.toJson());
    print('points added: ' + result.id);

    return;
  }
}