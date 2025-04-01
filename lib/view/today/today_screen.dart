import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controller/today_controller.dart';
import 'package:to_do/global_widgets/curved_btn.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      TodayController provider = context.read<TodayController>();

      await provider.getData();
      await provider.getTodoCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    TodayController provider = context.watch<TodayController>();
    bool isbordered = true;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                spacing: 10,
                children: [
                  CircleAvatar(
                    radius: 50, // Size of the circle
                    backgroundImage: NetworkImage(
                      'https://images.pexels.com/photos/9931681/pexels-photo-9931681.jpeg?auto=compress&cs=tinysrgb&w=600',
                    ),
                  ),
                  Text(
                    "John Samuel",
                    style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // to-do btn
                InkWell(
                  onTap: () async {
                    isbordered = true;
                    provider.showLoading();
                    provider.getData();
                    await Future.delayed(Duration(seconds: 2));
                    provider.hideLoading();
                  },
                  child: Container(
                    constraints: BoxConstraints(minHeight: 100, minWidth: 110),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      // color: Colors.red.shade200,
                      border:
                          isbordered == false
                              ? null
                              : Border.all(
                                color: Colors.deepPurpleAccent,
                                width: 2.0,
                              ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 2,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "To do",
                          style: TextStyle(
                            fontFamily: "Lato",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${provider.todoCount}",
                          style: TextStyle(
                            fontFamily: "Lato",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // completed btn
                InkWell(
                  onTap: () {
                    provider.getDataCompleted();
                  },
                  child: Container(
                    constraints: BoxConstraints(minHeight: 100, minWidth: 100),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 2,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Completed",
                          style: TextStyle(
                            fontFamily: "Lato",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${provider.completedCount}",
                          style: TextStyle(
                            fontFamily: "Lato",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            // task list UI
            Text(
              "Todays task",
              style: TextStyle(
                fontFamily: "Lato",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            Visibility(
              visible: provider.todayTaskList.isEmpty,
              child: Text("No tasks for today.."),
            ),
            Expanded(
              child: ListView.separated(
                // rectifys unwanted spaces - shrinkwrap
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: provider.todayTaskList.length,
                itemBuilder:
                    (context, index) => Padding(
                      padding: const EdgeInsets.all(5),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value:
                                      index == provider.updatedIndex
                                          ? provider.checkboxFlag
                                          : false,
                                  onChanged: (value) {
                                    provider.getTodoCount();
                                    provider.updateCheckboxToCompleted(
                                      value,
                                      index,
                                    );
                                  },
                                ),
                                Expanded(
                                  child: Text(
                                    provider.todayTaskList[index]["task"],
                                    style: TextStyle(
                                      fontFamily: "Lato",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                Visibility(
                                  visible:
                                      index == provider.updatedIndex
                                          ? true
                                          : false,
                                  child: Consumer<TodayController>(
                                    builder:
                                        (
                                          BuildContext context,
                                          value,
                                          Widget? child,
                                        ) => CurvedBtn(
                                          btnText: "done",
                                          bg: Colors.green,
                                          txtolor: Colors.white,
                                          vertical: 5,
                                          horizontal: 7,
                                          onClick: () async {
                                            //  value.showLoading();

                                            // await Future.delayed(
                                            //   Duration(seconds: 2),
                                            // );
                                            await value.updateStatus(
                                              "${value.todayTaskList[index]["id"]}",
                                            );
                                            await value.getData();
                                            await value.getTodoCount();
                                            // value.hideLoading();
                                          },
                                        ),
                                  ),
                                ),
                                SizedBox(width: 17),
                                //  Icon(Icons.)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 15),
                                Text(
                                  provider.checkCategoryForIcon(index),
                                  style: TextStyle(
                                    fontFamily: "Lato",
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    // ignore: void_checks
                                    return provider.showDialogBox(
                                      context,
                                      index,
                                    );
                                  },
                                  child: Card(
                                    elevation: 2.5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "View",
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                // CheckboxListTile(
                //   controlAffinity:
                //       ListTileControlAffinity
                //           .leading, // ✅ Moves checkbox to the left
                //   secondary: Icon(Icons.notifications),
                //   title: Text(provider.todayTaskList[index]["task"]),
                //   subtitle: ElevatedButton(
                //     onPressed: () {},
                //     child: Text("Move to completed"),
                //   ),
                //   value:
                //       index == provider.updatedIndex
                //           ? provider.checkboxFlag
                //           : false,
                //   onChanged: (value) {
                //     provider.updateCheckboxToCompleted(value, index);
                //   },
                // ),
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
