import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do/controller/add_todo_controller.dart';
import 'package:to_do/database/database_helper.dart';

class EditTaskController with ChangeNotifier {
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

  //
  String fetchtask = "";
  String fetchnotes = "";
  String fetchcategoryValue = "";
  String fetchdate = "";

  final ScrollController scrollController = ScrollController();

  static AddTodoController addTodoController = AddTodoController();

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
    } else if (dateController.text.isNotEmpty) {
      date = dateController.text;
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
    } else {
      date = dateController.text;
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

  Future<void> updateTaskToDB(
    String task,
    String notes,
    String date,
    String category,
    int id,
  ) async {
    log("update fn");
    id;
    await DatabaseHelper.updateRecord(
      task: taskTitle,
      notes: notes,
      date: date,
      category: category,
      id: id,
    );
    log("$id");
    notifyListeners();
  }

  void resetControllers() {
    taskTitleController.clear();
    taskNoteController.clear();
    dateController.clear();
    log("Controllers cleared");
  }

  getTaskOfId(dynamic list, int id, index) {
    log("$id");
   // id--;
    fetchtask = list[index]["task"];
    log("$id");
    fetchnotes = list[index]["note"];
    fetchdate = list[index]["date"];
    fetchcategoryValue = list[index]["category"];

    taskTitleController.text = fetchtask;
    taskNoteController.text = fetchnotes;
    dateController.text = fetchdate;
    categoryValue = fetchcategoryValue;
    // ✅ Corrected category assignments
    switch (categoryValue) {
      case "Priority":
        categoryCheckboxIndex = 0;
        break;
      case "Work":
        categoryCheckboxIndex = 1;
        break;
      case "Home":
        categoryCheckboxIndex = 2;
        break;
      case "Personal":
        categoryCheckboxIndex = 3;
        break;
      default:
        categoryCheckboxIndex = null;
    }
    // selectCheckbox(categoryCheckboxIndex!);
    log("fetchcategory: $fetchcategoryValue\n  ${list[id]["category"]}");
    log("fetchnote $fetchnotes\n  ${list[id]["note"]}");
    notifyListeners();
  }

  void scrollToSelected(int index) {
    // Scrolls to the selected checkbox
    double scrollPosition = index * 180.0; // Adjust based on item width
    scrollController.animateTo(
      scrollPosition,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
