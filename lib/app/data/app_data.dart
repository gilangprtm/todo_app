import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/app/utils/helpers/app_format.dart';

class AppData {
  var now = AppFormat.dateToString(DateTime.now());
  static List list = [];
  static String locale = "en";

  // reference to init box
  final myBox = Hive.box("mybox");

  void credentialData() {
    list = [
      {
        "nama": "Study",
        "deskripsi": "You can delete this",
        "tanggal": now,
        "selesai": true,
      },
      {
        "nama": "Exercise",
        "deskripsi": "You can delete this",
        "tanggal": now,
        "selesai": false,
      }
    ];
  }

  void loadData() {
    list = myBox.get("TODOLIST");
  }

  void updateData() {
    myBox.put("TODOLIST", list);
  }

  void updateLocale() {
    myBox.put("LOCALE", locale);
  }

  void loadLocale() {
    locale = myBox.get("LOCALE");
  }
}
