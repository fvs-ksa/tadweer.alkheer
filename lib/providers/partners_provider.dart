import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadweer_alkheer/models/partner.dart';
import '../locator.dart';
import '../services/crud_model.dart';

class PartnersProvider with ChangeNotifier {
  CRUDModel _crudeModel = locator<CRUDModel>();
  List<Partner> partners;

  PartnersProvider() {
    _crudeModel.setpath('partners');
  }

  Stream<QuerySnapshot> fetchAllPartnersAsStream() {
    return _crudeModel.streamAllDataCollection();
  }

  Future<List<Partner>> fetchPartners() async {
    var result = await _crudeModel.ref.get();

    partners = result.docs
        .map((doc) => Partner.fromMap(doc.data()))
        .toList();

    return partners;
  }

}