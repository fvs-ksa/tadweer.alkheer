import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tadweer_alkheer/models/task.dart';

import '../locator.dart';
import '../models/donation.dart';

import '../services/crud_model.dart';

class TasksProvider with ChangeNotifier {
  CRUDModel _crudeModel = locator<CRUDModel>();

  List<Task> tasks;

  TasksProvider() {
    _crudeModel.setpath('tasks');
  }

  Future<List<Task>> fetchTasks() async {
    var result = await _crudeModel.getDataCollection();

    tasks = result.docs
        .map((doc) => Task.fromMap(doc.data(), doc.id))
        .toList();
    return tasks;
  }

  Stream<QuerySnapshot> fetchTasksAsStream(String currentUid) {
    //getUser();
    return _crudeModel.streamDataCollectionWithEqual("driverId", currentUid);
  }

  Stream<QuerySnapshot> fetchAllTasksAsStream() {
    //getUser();
    return _crudeModel.streamAllDataCollection();
  }

  Future<Donation> getTaskById(String id) async {
    var doc = await _crudeModel.getDocumentById(id);
    return Donation.fromMap(doc.data(), doc.id);
  }

  Future removeTask(String id) async {
    await _crudeModel.removeDocument(id);
    return;
  }

  Future updateTask(Task data, String id) async {
    await _crudeModel.updateDocument(data.toJson(), id);
    return;
  }

  Future addTask(Task data) async {
    var result = await _crudeModel.addDocument(data.toJson());
    print('task added: ' + result.id);

    return;
  }
}
