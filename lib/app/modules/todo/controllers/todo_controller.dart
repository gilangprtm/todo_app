import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_hive/app/data/app_data.dart';
import 'package:todo_hive/app/utils/helpers/app_format.dart';
import 'package:todo_hive/app/utils/widget/app_input.dart';
import '../../../models/todo_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/theme/theme.dart';
import '../../../utils/widget/app_date.dart';

class TodoController extends GetxController {
  TextEditingController titleCon = TextEditingController();
  TextEditingController subtitleCon = TextEditingController();
  TextEditingController dateCon = TextEditingController();
  RxBool isChecked = false.obs;

  AppData db = AppData();
  RxList<TodoModel> hasil = <TodoModel>[].obs;
  List list = [];

  var myBox = Hive.box("mybox");

  @override
  void onInit() {
    if (myBox.get("TODOLIST") == null) {
      db.credentialData();
      hasilList();
    } else {
      db.loadData();
      hasilList();
    }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void hasilList() {
    hasil.value = AppData.list.map((e) => TodoModel.fromDynamic(e)).toList();
  }

  void checkBox(bool? value, int index) {
    isChecked.value = true;
    AppData.list[index]['selesai'] = !AppData.list[index]['selesai'];
    db.updateData();
    hasilList();
    isChecked.value = false;
  }

  void deleteData(int index) {
    AppData.list.removeAt(index);
    db.updateData();
    hasilList();
  }

  void viewButton(int index) {
    titleCon.text = hasil[index].nama!;
    subtitleCon.text = hasil[index].deskripsi ?? "";
    dateCon.text = AppFormat.displayDate(hasil[index].tanggal);

    Get.bottomSheet(Container(
      height: 500,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 5,
              width: 100,
              decoration: BoxDecoration(
                color: AppColor.grey3,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ),
          Container(
            height: 400,
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppInputText(
                    label: "Title",
                    textCon: titleCon,
                    isReadOnly: true,
                  ),
                  AppInputText(
                    label: "Description",
                    textCon: subtitleCon,
                    hintText: "description",
                    isDescription: true,
                    isReadOnly: true,
                  ),
                  AppDateInput(
                    label: "Date",
                    textCon: dateCon,
                    isEdit: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  void addButton() {
    Get.toNamed(Routes.ADD_TODO);
  }
}
