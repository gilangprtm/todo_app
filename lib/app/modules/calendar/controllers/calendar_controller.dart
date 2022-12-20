import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/app_data.dart';
import '../../../models/todo_model.dart';
import '../../../utils/helpers/app_format.dart';
import '../../../utils/theme/theme.dart';
import '../../../utils/widget/app_date.dart';
import '../../../utils/widget/app_input.dart';

class CalendarController extends GetxController {
  TextEditingController titleCon = TextEditingController();
  TextEditingController subtitleCon = TextEditingController();
  TextEditingController dateCon = TextEditingController();
  var focusDate = DateTime.now().obs;
  RxList<TodoModel> hasil = <TodoModel>[].obs;
  RxList<TodoModel> listData = <TodoModel>[].obs;

  @override
  void onInit() {
    hasilList();
    DateTime tgl =
        AppFormat.stringToDateTime(AppFormat.dateToString(focusDate.value))!;
    listData.value =
        hasil.where((e) => e.tanggal == tgl && e.selesai == false).toList();
    super.onInit();
  }

  @override
  void onClose() {}

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    focusDate.value = selectedDay;

    hasil.clear();
    hasilList();
    DateTime tgl =
        AppFormat.stringToDateTime(AppFormat.dateToString(focusDate.value))!;
    listData.value =
        hasil.where((e) => e.tanggal == tgl && e.selesai == false).toList();
  }

  void hasilList() {
    hasil.value = AppData.list.map((e) => TodoModel.fromDynamic(e)).toList();
  }

  void viewButton(int index) {
    titleCon.text = listData[index].nama!;
    subtitleCon.text = listData[index].deskripsi ?? "";
    dateCon.text = AppFormat.displayDate(listData[index].tanggal);

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
}
