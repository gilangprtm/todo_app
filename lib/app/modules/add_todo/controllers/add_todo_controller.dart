import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_hive/app/data/app_data.dart';
import 'package:todo_hive/app/utils/helpers/app_format.dart';
import 'package:todo_hive/app/utils/helpers/helpers.dart';

import '../../../routes/app_pages.dart';

class AddTodoController extends GetxController {
  TextEditingController titleCon = TextEditingController();
  TextEditingController subtitleCon = TextEditingController();
  TextEditingController dateCon = TextEditingController();

  AppData db = AppData();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void saveButton() {
    if (titleCon.text.isEmpty) {
      AppHelper.dialogWarning('warning_no_title'.tr);
    } else {
      tambahData();
      db.updateData();
      Get.offAllNamed(Routes.HOME);
    }
  }

  void tambahData() {
    AppData.list.add({
      "nama": titleCon.text,
      "selesai": false,
      "tanggal": dateCon.text != ''
          ? AppFormat.dateToString(DateTime.parse(dateCon.text))
          : null,
      "deskripsi": dateCon.text != '' ? subtitleCon.text : null,
    });
  }
}
