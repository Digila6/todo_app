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

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // to-do btn
                InkWell(
                  onTap: () async {
                    provider.showLoading();
                    provider.getData();
                    await Future.delayed(Duration(seconds: 2));
                    provider.hideLoading();
                  },
                  child: Container(
                    constraints: BoxConstraints(minHeight: 100, minWidth: 110),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade200,
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
                      children: [Text("To do"), Text("${provider.todoCount}")],
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
                      color: Colors.green.shade200,
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
                        Text("Completed"),
                        Text("${provider.completedCount}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),
            // task list UI
            Text(
              "Todays task",
              style: TextStyle(fontFamily: "Lato", fontSize: 16),
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
                                          horizontal: 5,
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
                                //  Icon(Icons.)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: 15),
                                Text(provider.checkCategoryForIcon(index)),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    // ignore: void_checks
                                    return provider.showDialogBox(
                                      context,
                                      index,
                                    );
                                  },
                                  child: Text(
                                    "view",
                                    style: TextStyle(
                                      color: Colors.deepPurpleAccent,
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
