import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:to_do/database/database_helper.dart';

class AllTasksController with ChangeNotifier {
  static List<Map<dynamic, dynamic>>? allTasks = [];

  Future<void> getAllTasksLatestOrder() async {
    allTasks = await DatabaseHelper.getLatestRecord();
    notifyListeners();
  }

  Future<void> getAllData() async {
    allTasks = await DatabaseHelper.fetchDataFromDb();
    notifyListeners();
  }

  Future deleteRecord(int id) async {
    await DatabaseHelper.deleteRecord(id);
    log("deleted record");
    notifyListeners();
  }
}
