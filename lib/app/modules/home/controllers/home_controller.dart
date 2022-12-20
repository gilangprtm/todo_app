import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:todo_hive/app/utils/helpers/helpers.dart';

import '../../../data/app_data.dart';
import '../../../models/languange_model.dart';
import '../../../utils/widget/app_dropdown.dart';

class HomeController extends GetxController {
  List<LanguangeModel> items = [
    LanguangeModel(bahasa: "English", code: "en"),
    LanguangeModel(bahasa: "Indonesia", code: "id"),
  ];

  RxString selectedItem = "".obs;

  AppData db = AppData();

  @override
  void onInit() {
    FlutterNativeSplash.remove();
    checkLanguange();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void onSetting() {
    // Get.toNamed(Routes.SETTING);
    AppHelper.dialogCustomWidget([
      Obx(() {
        return AppDropdownInput(
          label: "languange".tr,
          hintText: "chose_languange".tr,
          items: items.map((e) => e.bahasa).toList(),
          value: selectedItem.value,
          onChanged: (value) {
            choseLanguange(value!);
          },
        );
      }),
    ]);
  }

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
