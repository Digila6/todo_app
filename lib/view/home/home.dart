import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:to_do/view/add_todo/add_todo.dart';
import 'package:to_do/view/today/today_screen.dart';
import 'package:to_do/view/all_tasks/all_tasks.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 0;
  List<Widget> screens = [TodayScreen(), AddTodo(), AllTasks()];
  List<String> appbarTitles = ["Today", "Add Tasks", "View Tasks"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appbarTitles[currentIndex],
          style: TextStyle(fontFamily: "Lato", fontWeight: FontWeight.bold),
        ),
      ),
      body: screens[currentIndex],
      bottomNavigationBar: Card(
        elevation: 2.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        surfaceTintColor: Colors.deepPurple,
        child: SalomonBottomBar(
          onTap: (index) {
            currentIndex = index;
            setState(() {});
          },
          itemShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          currentIndex: currentIndex,
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.today),
              title: Text("Today"),
              selectedColor: Colors.deepPurpleAccent,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.add_task),
              title: Text("Add Tasks"),
              selectedColor: Colors.pink,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.upcoming),
              title: Text("View Tasks"),
              selectedColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
