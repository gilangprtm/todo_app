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
        title: Text('add_todo_title'.tr),
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
                    label: "title".tr,
                    textCon: controller.titleCon,
                  ),
                  AppInputText(
                    label: "description".tr,
                    textCon: controller.subtitleCon,
                    isDescription: true,
                  ),
                  AppDateInput(
                    label: "date".tr,
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
                    text: "save".tr,
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
