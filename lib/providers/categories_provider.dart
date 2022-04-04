import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../locator.dart';
import '../services/crud_model.dart';

class CategoriesProvider with ChangeNotifier {
  CRUDModel _crudeModel = locator<CRUDModel>();

  CategoriesProvider() {
    _crudeModel.setpath('categories');
  }

  Stream<QuerySnapshot> fetchAllCategoriesAsStream() {
    return _crudeModel.streamAllDataCollection();
  }

}