import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_hive/app/utils/widget/app_button.dart';
import '../../../utils/widget/app_date.dart';
import '../../../utils/widget/app_input.dart';
import '../controllers/add_todo_controller.dart';

class AddTodoView extends GetView<AddTodoController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AddTodoView'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  AppInputText(
                    label: "Title",
                    textCon: controller.titleCon,
                  ),
                  AppInputText(
                    label: "Description",
                    textCon: controller.subtitleCon,
                    isDescription: true,
                  ),
                  AppDateInput(
                    label: "Date",
                    textCon: controller.dateCon,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                    text: "Save",
                    onTap: () {
                      controller.saveButton();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
