import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_hive/app/utils/src/translation.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/services_init.dart';
import 'app/utils/theme/theme.dart';

void main() async {
  await ProjectService.init();
  runApp(
    GetMaterialApp(
      translations: AppTranslation(),
      locale: Locale('en'),
      debugShowCheckedModeBanner: false,
      title: "ToDo App",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: lightTheme(),
    ),
  );
}
