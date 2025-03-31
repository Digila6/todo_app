import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/controller/add_todo_controller.dart';
import 'package:to_do/database/database_helper.dart';
import 'package:to_do/global_widgets/curved_btn.dart';
import 'package:to_do/util/constants/color_constants.dart';
import 'package:to_do/view/home/home.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({super.key});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      AddTodoController provider = context.watch<AddTodoController>();
      provider.resetControllers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    AddTodoController provider = context.watch<AddTodoController>();

    TextEditingController taskBrief = TextEditingController();
    TextEditingController notes = TextEditingController();

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Consumer<AddTodoController>(
          builder:
              (BuildContext context, value, Widget? child) => Form(
                key: formKey,
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Task Brief",
                      style: TextStyle(fontSize: 16, fontFamily: "Lato"),
                    ),
                    TextFormField(
                      controller: provider.taskTitleController,
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
                          value.dateController, // 📅 Text field to display date
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: "Select Date",
                        labelStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade400,
                        ),
                        // value.date.isEmpty ? "Select Date" : value.date,
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      //  readOnly: true,
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
                                  // categoryCheck = true;
                                  // controller.categoryCheckboxIndex = index;
                                  //  value?.selectCheckbox(index);
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
                      //   validator: (text) => value.checktaskNotes(text),
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
                                btnText: "Add task",
                                horizontal: 5,
                                vertical: 5,
                                bg: ColorConstants.primary,
                                onClick: () async {
                                  if (provider.validateForm(formKey)) {
                                    value.showLoading();

                                    value.checktaskNotes(notes.text);
                                    await Future.delayed(
                                      Duration(seconds: 2),
                                    ); // Simulate DB call
                                    //  await AddTodoController.initDb();
                                    DatabaseHelper.addTaskToDB(
                                      value.taskTitle,
                                      value.notes,
                                      value.date,
                                      value.categoryValue,
                                      "todo",
                                    );
                                    value.hideLoading();
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Form submitted successfully!",
                                        ),
                                      ),
                                    );
                                    value.resetControllers();

                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Home(),
                                      ),
                                    );
                                  }
                                },
                              ),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
