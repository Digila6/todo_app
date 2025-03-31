import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:to_do/controller/add_todo_controller.dart';
import 'package:to_do/database/database_helper.dart';
import 'package:to_do/global_widgets/curved_btn.dart';

class TodayController with ChangeNotifier {
  List<Map> todayTaskList = [];

  //checkbox updation
  bool? checkboxFlag;
  int? updatedIndex;

  bool? taskCompletedBtn = false;
  bool isLoading = false;

  int todoCount = 0;
  int completedCount = 0;

  Future<void> getData() async {
   await  DatabaseHelper.initDb();
    todayTaskList = await DatabaseHelper.fetchDataFromDbTodo();
    if(todayTaskList.isEmpty){
      
    }
    
    notifyListeners();
  }

  Future<void> getDataCompleted() async {
    await DatabaseHelper.initDb();
    todayTaskList = await DatabaseHelper.fetchDataFromDbCompl();
    notifyListeners();
  }

  updateCheckboxToCompleted(bool? value, int index) {
    if (value == true) {
      checkboxFlag = value;
      updatedIndex = index;
      taskCompletedBtn = true;
    } else {
      checkboxFlag = false;
      updatedIndex = null;
      taskCompletedBtn = false;
    }
    notifyListeners();
  }

  checkCategoryForIcon(int index) {
    if (todayTaskList[index]["category"] == "Priority") {
      return "📌: Priority";
    } else if (todayTaskList[index]["category"] == "Home") {
      return "🏠: Home";
    } else if (todayTaskList[index]["category"] == "Work") {
      return "💼: Work";
    } else {
      return "😊: Personal";
    }
  }

  updateStatus(String index) {
    DatabaseHelper.updateTaskStatus(index: index);
    getData();
    notifyListeners();
  }

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

  Future<void> getTodoCount() async {
    log("task count fn called");
    await DatabaseHelper.getCount();
    todoCount = DatabaseHelper.todoCOunt;
    completedCount = DatabaseHelper.completedCount;
    notifyListeners();
  }

  showDialogBox(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            scrollable: true,
            title: Center(child: Text("View Task")),
            titleTextStyle: TextStyle(
              fontFamily: "Lato",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  spacing: 2,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Task",
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontStyle: FontStyle.italic,
                        //  fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      todayTaskList[index]["task"],
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Note",
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontStyle: FontStyle.italic,

                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      todayTaskList[index]["note"],
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Category: ${checkCategoryForIcon(index)}",
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontStyle: FontStyle.italic,

                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Due by: ${todayTaskList[index]["date"]}",
                      style: TextStyle(
                        fontFamily: "Lato",
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              CurvedBtn(
                btnText: "OK",
                vertical: 5,
                bg: Colors.deepPurpleAccent,
                txtolor: Colors.white,
                onClick: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }
}
