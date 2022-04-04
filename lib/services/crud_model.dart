import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class CRUDModel {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String path = '';
  CollectionReference ref;
  void setpath(String path) {
    this.path = path;
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.get();
  }

  Stream<QuerySnapshot> streamAllDataCollection() {
    try {
      return ref.snapshots();
    } catch (error) {
      print(error);
    }
    return null;
  }

  Stream<QuerySnapshot> streamDataCollectionWithEqual(
      String field, String equalTo) {
    try {
      return ref.orderBy('date',descending: true).where(field, isEqualTo: equalTo).snapshots();
    } catch (error) {
      print(error);
    }
    return null;
  }

  Stream<QuerySnapshot> streamDataCollectionWithContains(
      String field, String equalTo) {
    try {
      return ref.where(field, arrayContains: equalTo).snapshots();
    } catch (error) {
      print(error);
    }
    return null;
  }

  Stream<QuerySnapshot> streamDataCollectionOrdered(String field) {
    try {
      return ref.orderBy(field).snapshots();
    } catch (error) {
      print(error);
    }
    return null;
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }

  Future<void> removeDocument(String id) {
    return ref.doc(id).delete();
  }

  Future<DocumentReference> addDocument(Map<String, dynamic> data) {
    return ref.add(data);
  }

  Future<void> addDocumentWithId(Map<String, dynamic> data, String id) {
    return ref.doc(id).set(data);
  }

  Future<void> updateDocument(Map<String, dynamic> data, String id) {
    return ref.doc(id).update(data);
  }
}
