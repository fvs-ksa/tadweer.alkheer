import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../locator.dart';
import '../models/donation.dart';

import '../services/crud_model.dart';

class DonationsProvider with ChangeNotifier {
  CRUDModel _crudeModel = locator<CRUDModel>();

  List<Donation> donations;

  DonationsProvider() {
    _crudeModel.setpath('donations');
  }

  Future<List<Donation>> fetchDonations() async {
    var result = await _crudeModel.ref.orderBy('date', descending: true).get();

    donations = result.docs
        .map((doc) => Donation.fromMap(doc.data(), doc.id))
        .toList();
    return donations;
  }

  Stream<QuerySnapshot> fetchDonationsAsStream(String currentUid) {
    return _crudeModel.streamDataCollectionWithEqual("userId", currentUid);
  }

  Stream<QuerySnapshot> fetchAllDonationsAsStream() {
    return _crudeModel.streamAllDataCollection();
  }

  Future<Donation> getDonationById(String id) async {
    var doc = await _crudeModel.getDocumentById(id);
    return Donation.fromMap(doc.data(), doc.id);
  }

  Future removeDonation(String id) async {
    await _crudeModel.removeDocument(id);
    return;
  }

  Future updateDonation(Donation data, String id) async {
    await _crudeModel.updateDocument(data.toJson(), id);
    return;
  }

  Future<DocumentReference> addDonation(Donation data) async {
    var result = await _crudeModel.addDocument(data.toJson());
    print('donation added: ' + result.id);

    return result;
  }
}
