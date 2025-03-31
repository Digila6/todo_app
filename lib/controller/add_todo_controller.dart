import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class AddTodoController with ChangeNotifier {
  IconData? icon;
  List<String> category = ["Priority", "Work", "Home", "Personal"];
  int? categoryCheckboxIndex;

  //values to pass to db
  String categoryValue = "";
  String notes = "";
  String taskTitle = "";
  String date = "";

  TextEditingController dateController = TextEditingController();
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskNoteController = TextEditingController();
  bool isLoading = false; // ✅ Add a loading state

  //database instance
  static late Database database;
  static List<Map> todoList = [];
  static int todoCOunt = 0;
  static int completedCount = 0;

  //calender fn
  Future<void> selectDate(BuildContext context) async {
    DateTime? pickDate = await showDatePicker(
      context: context,
      //  initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickDate != null) {
      date = DateFormat('dd-MM-yyyy').format(pickDate); // Format date
      dateController.text = date; // Update TextField
      debugPrint("Selected Date: $date");
    } else {
      dateController.text = "";
    }
  }

  //checkboxtile fn
  void selectCheckbox(int index) {
    if (categoryCheckboxIndex == index) {
      categoryCheckboxIndex = null; // Deselect if clicked again
    } else {
      categoryCheckboxIndex = index; // Update selection
      categoryValue = category[index];
    }
    notifyListeners();
  }

  //show loading
  void showLoading() {
    CircularProgressIndicator(
      strokeWidth: 6, // Thicker stroke
      backgroundColor: Colors.grey[300], // Background color
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Spinner color
    );
    isLoading = true;
    notifyListeners();
  }

  void hideLoading() {
    isLoading = false;
    notifyListeners();
  }

  String? checktaskTitle(String? value) {
    if (value!.trim().isEmpty) {
      return "Task title cannot be empty!";
    }
    taskTitle = value;
    return null; // no error
  }

  String? checktaskNotes(String? value) {
    if (value!.trim().isEmpty) {
      return "";
    } else {
      // need to handle if there is data added
      notes = value;
      return null;
    }
  }

  String? checkDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Date cannot be empty!";
    }
    return null;
  }

  bool validateForm(GlobalKey<FormState> formKey) {
    // debugPrint("button tapped");
    if (formKey.currentState!.validate()) {
      // ✅ Proceed if input is valid
      notifyListeners();
      log(notes);
      return true;
    } else {
      return false;
    }
  }

  void resetControllers() {
    taskTitleController.clear();
    taskNoteController.clear();
    dateController.clear();
    log("Controllers cleared");
  }
}
