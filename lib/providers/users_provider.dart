import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../locator.dart';
import '../models/user.dart';

import '../services/crud_model.dart';

class UsersProvider with ChangeNotifier {
  CRUDModel _crudeModel = locator<CRUDModel>();

  List<User> users ;
  var firebaseUser;

  UsersProvider() {
    _crudeModel.setpath('users');
  }


  Future<User> getUserById(String id) async {
    var doc = await _crudeModel.getDocumentById(id);
    return User.fromMap(doc.data(), doc.id);
  }

  Future updateUser(User data, String id) async {
    await _crudeModel.updateDocument(data.toJson(), id);
    return;
  }

  Future addUser(User data, String id) async {
    await _crudeModel.addDocumentWithId(data.toJson(), id);
    print('user added' + id);

    return;
  }
}