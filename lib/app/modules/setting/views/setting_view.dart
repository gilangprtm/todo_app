import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../utils/widget/app_dropdown.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('setting'.tr),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: Column(
          children: [
            Obx(() {
              return AppDropdownInput(
                label: "languange".tr,
                hintText: "chose_languange".tr,
                items: controller.items.map((e) => e.bahasa).toList(),
                value: controller.selectedItem.value,
                onChanged: (value) {
                  controller.choseLanguange(value!);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
