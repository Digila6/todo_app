import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controller/all_tasks_controller.dart';
import 'package:to_do/database/database_helper.dart';
import 'package:to_do/view/edit_task/edit_task.dart';

class AllTasks extends StatefulWidget {
  const AllTasks({super.key});

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      AllTasksController providerRead = context.read<AllTasksController>();
      // providerRead.getAllTasksLatestOrder();
      await DatabaseHelper.initDb();
      await providerRead.getAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // AllTasksController provider = context.watch<AllTasksController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<AllTasksController>(
            builder:
                (
                  BuildContext context,
                  value,
                  Widget? child,
                ) => ListView.builder(
                  // rectifys unwanted spaces - shrinkwrap
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  //padding: EdgeInsets.all(10),
                  padding: EdgeInsets.zero,
                  itemCount: AllTasksController.allTasks?.length ?? 0,
                  itemBuilder:
                      (context, index) => Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 2,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "📅 " +
                                        AllTasksController
                                            .allTasks?[index]["date"],
                                    style: TextStyle(
                                      fontFamily: "Lato",

                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                  // InkWell(
                                  //   onTap: () {},
                                  //   child: Icon(Icons.expand_more),
                                  // ),
                                ],
                              ),
                              Row(
                                spacing: 30,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // ignore: prefer_interpolation_to_compose_strings
                                  Expanded(
                                    child: Text(
                                      AllTasksController
                                          .allTasks?[index]["task"],
                                      style: TextStyle(
                                        fontFamily: "Lato",
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  // Icon(Icons.edit, color: Colors.grey.shade600),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                // mainAxisSize: MainAxisSize.max,
                                spacing: 8,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    color: Colors.deepPurpleAccent,
                                    size: 8, // Adjust size for a smaller dot
                                  ),
                                  Text(
                                    " ${AllTasksController.allTasks?[index]["status"]}",
                                  ),

                                  Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      log("message");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => EditTask(
                                                AllTasksController.allTasks,
                                                index,
                                              ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.deepPurpleAccent.shade400,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      //  log("delete id $index");
                                      await value.deleteRecord(index);
                                      await value.getAllData();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                ),
          ),
        ),
      ),
    );
  }
}
