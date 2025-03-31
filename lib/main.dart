import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/controller/add_todo_controller.dart';
import 'package:to_do/controller/all_tasks_controller.dart';
import 'package:to_do/controller/edit_task_controller.dart';
import 'package:to_do/controller/today_controller.dart';
import 'package:to_do/database/database_helper.dart';
import 'package:to_do/view/home/home.dart';

Future <void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
   
  await DatabaseHelper.initDb();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AddTodoController()),
        ChangeNotifierProvider(create: (context) => TodayController()),
        ChangeNotifierProvider(create: (context) => AllTasksController()),
         ChangeNotifierProvider(create: (context) => EditTaskController()),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, home: Home()),
    );
  }
}
