import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_hive/app/utils/theme/app_color.dart';
import 'package:uuid/uuid.dart';

class AppHelper {
  static BorderRadius get cicularRadius => BorderRadius.circular(15);

  static String idGenerator() {
    const uuid = Uuid();
    var r = uuid.v4();
    return r;
  }

  static Future dialogWarning(String? message) async {
    await Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_rounded,
              color: AppColor.yellow,
              size: 40,
            ),
            const Padding(padding: EdgeInsets.all(7)),
            Text(
              textAlign: TextAlign.center,
              message ?? "-",
              style: const TextStyle(
                color: AppColor.yellow,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future dialogSuccess(String? message) async {
    await Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColor.blue2,
              size: 40,
            ),
            const Padding(padding: EdgeInsets.all(7)),
            Text(
              textAlign: TextAlign.center,
              message ?? "-",
              style: const TextStyle(
                color: AppColor.blue2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future dialogCustomWidget(List<Widget> children) async {
    await Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppHelper.cicularRadius),
        content: Column(mainAxisSize: MainAxisSize.min, children: children),
        contentPadding:
            const EdgeInsets.only(bottom: 0, top: 20, right: 10, left: 10),
        actionsPadding:
            const EdgeInsets.only(top: 0, bottom: 5, left: 20, right: 20),
        actions: [
          TextButton(
            child: Text('close'.tr),
            onPressed: () {
              Get.back(result: false);
            },
          ),
        ],
      ),
    );
  }
}
