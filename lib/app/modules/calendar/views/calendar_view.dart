import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_hive/app/utils/extension/box_extension.dart';
import 'package:todo_hive/app/utils/theme/app_color.dart';
import '../../../utils/helpers/helpers.dart';
import '../controllers/calendar_controller.dart';

class CalendarView extends GetView<CalendarController> {
  final CalendarController c = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView(
        children: [
          TableCalendar(
              locale: 'id_ID',
              firstDay: DateTime(c.focusDate.value.year - 10, 1, 1),
              lastDay: DateTime(c.focusDate.value.year + 10, 1, 1),
              focusedDay: c.focusDate.value,
              headerStyle: const HeaderStyle(
                titleTextStyle: TextStyle(
                  color: AppColor.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                titleCentered: true,
                formatButtonVisible: false,
              ),
              availableGestures: AvailableGestures.all,
              startingDayOfWeek: StartingDayOfWeek.monday,
              onDaySelected: c.onDaySelected,
              selectedDayPredicate: (day) => isSameDay(day, c.focusDate.value)),
          5.heightBox,
          Container(
            color: AppColor.lightgrey,
            height: 5,
          ),
          ListView.builder(
            itemCount: c.listData.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: GestureDetector(
                  onTap: () => c.viewButton(index),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: AppHelper.cicularRadius,
                      color: c.listData[index].selesai == true
                          ? Colors.grey[200]
                          : AppColor.blue3,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            c.listData[index].nama!,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          30.heightBox,
        ],
      );
    });
  }
}
