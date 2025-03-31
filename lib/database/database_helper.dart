import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  //database instance
  static late Database database;
  static List<Map> todoList = [];
  static int todoCOunt = 0;
  static int completedCount = 0;

  // create  database- table
  static Future<void> initDb() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    database = await openDatabase(
      "note.db",
      version: 1,
      onCreate:
          (db, version) async => await db.execute(
            'CREATE TABLE Note (id INTEGER PRIMARY KEY, task TEXT, note TEXT, date TEXT,category TEXT,status TEXT)',
          ),
    );
    log("db created : ${database.path},");

    fetchDataFromDb();
    // AddTodoController.deleteDB(database);
    // log("db deleted");
  }

  //insert data into db
  static Future<void> addTaskToDB(
    String taskTitle,
    String notes,
    String date,
    String category,
    String? status,
  ) async {
    if (database.isOpen == false) {
      log("⚠️ Database not initialized! Initializing now...");
      await initDb();
    }

    await database.rawInsert(
      'INSERT INTO Note(task, note, date,category,status) VALUES(?, ?, ?, ?,? )',
      [taskTitle, notes, date, category, status],
    );
    database = await openDatabase("note.db");
    await logAllData(database);
  }

  static Future<void> logAllData(Database database) async {
    try {
      List<Map<String, dynamic>> result = await database.rawQuery(
        'SELECT * FROM Note',
      );

      if (result.isEmpty) {
        log("🔍 No data found in the Test table.");
      } else {
        for (var row in result) {
          log("📌 Row: $row"); // Print each row properly
        }
      }
    } catch (e) {
      log('❌ Error fetching data: $e');
    }
  }

  static Future<void> deleteDB(Database database) async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'note.db');
    // Delete the database
    await deleteDatabase(path);
    log("db deleted");
  }

  static Future<void> deleteTable() async {
    await database.execute("DROP TABLE IF EXISTS Note");
    debugPrint("Table deleted successfully!");
    log("Table deleted successfully!");
  }

  // today screen get all data
  static Future<List<Map>>? fetchDataFromDb() async {
    todoList = await database.rawQuery("SELECT * FROM Note ");
    log(todoList.toString());
    return todoList;
  }

  static Future<List<Map>> fetchDataFromDbTodo() async {
    todoList = await database.rawQuery(
      "SELECT * FROM Note WHERE status = 'todo'",
    );
    log(todoList.toString());
    return todoList;
  }

  static Future<List<Map>> fetchDataFromDbID(int index) async {
    List<Map<String, dynamic>> todoList = await database.rawQuery(
      "SELECT * FROM Note WHERE id = ?",
      [index],
    );
    log(todoList.toString());
    return todoList;
  }

  static Future<List<Map>> fetchDataFromDbCompl() async {
    todoList = await database.rawQuery(
      "SELECT * FROM Note WHERE status = 'completed'",
    );
    log(todoList.toString());
    return todoList;
  }

  static Future<void> updateTaskStatus({required String index}) async {
    await database.rawUpdate('UPDATE Note SET  status = ? WHERE id =?', [
      "completed",
      index,
    ]);
  }

  static Future<void> getCount() async {
    List<Map<String, dynamic>> taskList = await database.rawQuery(
      "SELECT COUNT(*) as count FROM Note WHERE status = 'todo'",
    );
    List<Map<String, dynamic>> taskComplList = await database.rawQuery(
      "SELECT COUNT(*) as count FROM Note WHERE status = 'completed'",
    );
    todoCOunt =
        taskList.isNotEmpty && taskList.first["count"] != null
            ? taskList.first["count"] as int
            : 0;
    completedCount =
        taskComplList.isNotEmpty && taskComplList.first["count"] != null
            ? taskComplList.first["count"] as int
            : 0;
    log("todo count: $todoCOunt\n completed count: $completedCount");
  }

  //fetch records in the latest date
  static getLatestRecord() async {
    List<Map<String, dynamic>> latestList = await database.rawQuery(
      "SELECT * FROM Note ORDER BY date DESC",
    );
    return latestList.isNotEmpty ? latestList : [];
  }

  static Future<void> updateRecord({
    required String task,
    required String notes,
    required String date,
    required String category,
    required int id,
  }) async {
    final db = database;
    await db.rawUpdate(
      'UPDATE Note SET task=?,note=?, date=?,category=?,status=?  WHERE id=?',
      [task, notes, date, category, "todo", id],
    );
    log("updated");
  }

  static Future<void> deleteRecord(int id) async {
    if (database.isOpen == false) {
      log("⚠️ Database not initialized! Initializing now...");
      await initDb();
    }

    await database.rawDelete('DELETE FROM Note WHERE id = ?', [id]);
    log("deleted record with id $id");
  }

  // task, note, date,category,status
}
