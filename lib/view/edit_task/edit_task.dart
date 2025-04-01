import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controller/all_tasks_controller.dart';
import 'package:to_do/controller/edit_task_controller.dart';
import 'package:to_do/global_widgets/curved_btn.dart';
import 'package:to_do/util/constants/color_constants.dart';

class EditTask extends StatefulWidget {
  final List<Map<dynamic, dynamic>>? allTask;
  final int id;
  final index;

  const EditTask(this.allTask, this.id, this.index, {super.key});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
      final provider = context.read<EditTaskController>();
      provider.getTaskOfId(widget.allTask, widget.id, widget.index);

      Future.delayed(Duration(milliseconds: 300), () {
        log("edit class init: ${widget.id}");
        if (provider.categoryCheckboxIndex != null) {
          provider.scrollToSelected(provider.categoryCheckboxIndex!);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    EditTaskController provider = context.watch<EditTaskController>();

    TextEditingController taskBrief = TextEditingController();
    TextEditingController notes = provider.taskNoteController;

    return Scaffold(
      appBar: AppBar(title: Text("Edit Task")),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Consumer<EditTaskController>(
            builder:
                (BuildContext context, value, Widget? child) => Form(
                  key: formKey,
                  child: Center(
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Task Brief",
                          style: TextStyle(fontSize: 16, fontFamily: "Lato"),
                        ),
                        TextFormField(
                          controller: value.taskTitleController,
                          textCapitalization: TextCapitalization.sentences,
                          minLines: 1,
                          maxLines: 4,
                          validator: (text) => value.checktaskTitle(text),
                          onTap: () {
                            taskBrief.clear();
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            labelText: "whats your new task ??",
                            labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade400,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Text(
                          "Set date",
                          style: TextStyle(fontSize: 16, fontFamily: "Lato"),
                        ),
                        TextFormField(
                          readOnly: true, // Prevent manual typing
                          validator: (date) => value.checkDate(date),
                          controller:
                              value
                                  .dateController, // 📅 Text field to display date
                          autovalidateMode: AutovalidateMode.onUserInteraction,

                          decoration: InputDecoration(
                            labelText: "Select Date",
                            labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade400,
                            ),

                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.calendar_today),
                          ),

                          onTap: () => value.selectDate(context),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Choose category",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Lato",
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: ListView.separated(
                            controller: value.scrollController,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder:
                                (context, index) => SizedBox(
                                  width: 170,
                                  height: 50,
                                  child: CheckboxListTile(
                                    value: value.categoryCheckboxIndex == index,
                                    title: Text(value.category[index]),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onChanged: (value) {
                                      provider.selectCheckbox(index);
                                    },
                                  ),
                                ),
                            separatorBuilder:
                                (context, index) => SizedBox(width: 20),
                            itemCount: value.category.length,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          minLines: 3,
                          maxLines: 6,
                          controller: notes,
                          textCapitalization: TextCapitalization.sentences,

                          onTap: () {
                            notes.clear();
                          },
                          decoration: InputDecoration(
                            labelText: "Any notes??",
                            labelStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child:
                              value.isLoading
                                  ? CircularProgressIndicator()
                                  : CurvedBtn(
                                    btnText: "Submit",
                                    horizontal: 10,
                                    vertical: 4,
                                    bg: Colors.deepPurpleAccent,
                                    onClick: () async {
                                      if (provider.validateForm(formKey)) {
                                        value.showLoading();

                                        value.checktaskNotes(notes.text);
                                        // await Future.delayed(
                                        //   Duration(seconds: 2),
                                        // ); // Simulate DB call
                                        //  await AddTodoController.initDb();
                                        log("update :");
                                        log("date updated: ${value.date}");
                                        await value.updateTaskToDB(
                                          value.taskTitle,
                                          value.notes,
                                          value.date,
                                          value.categoryValue,
                                          widget.id,
                                        );

                                        value.hideLoading();
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Task updated successfully!",
                                            ),
                                          ),
                                        );

                                        //  value.resetControllers();
                                        context
                                            .read<AllTasksController>()
                                            .getAllData();
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                      }
                                    },
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
