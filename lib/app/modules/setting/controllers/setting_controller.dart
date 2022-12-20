import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:todo_hive/app/data/app_data.dart';

import '../../../models/languange_model.dart';

class SettingController extends GetxController {
  List<LanguangeModel> items = [
    LanguangeModel(bahasa: "English", code: "en"),
    LanguangeModel(bahasa: "Indonesia", code: "id"),
  ];

  RxString selectedItem = "".obs;

  AppData db = AppData();

  @override
  void onInit() {
    checkLanguange();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void choseLanguange(String bahasa) {
    var locale = items.where((element) => element.bahasa == bahasa).first;
    selectedItem.value = bahasa;
    AppData.locale = locale.code!;
    Get.updateLocale(Locale(locale.code!));
    db.updateLocale();
  }

  void checkLanguange() {
    var locale = items.where((e) => e.code == AppData.locale).first;
    selectedItem.value = locale.bahasa ?? "";
  }
}
