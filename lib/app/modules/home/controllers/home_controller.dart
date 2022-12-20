import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:todo_hive/app/data/app_data.dart';
import 'package:todo_hive/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final count = 0.obs;
  AppData db = AppData();
  @override
  void onInit() {
    FlutterNativeSplash.remove();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  void onSetting() {
    Get.toNamed(Routes.SETTING);
    // AppData.locale = 'en';
    // Get.updateLocale(Locale(AppData.locale));
    // db.updateLocale();
  }
}
