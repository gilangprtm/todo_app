import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:todo_hive/app/utils/theme/app_color.dart';

import '../../calendar/views/calendar_view.dart';
import '../../todo/views/todo_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                  icon: Icon(
                Icons.list_rounded,
                color: AppColor.white,
              )),
              Tab(
                  icon: Icon(
                Icons.calendar_month_outlined,
                color: AppColor.white,
              )),
            ],
          ),
          title: Text("ToDo"),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                controller.onSetting();
              },
              icon: const Icon(
                Icons.settings,
                size: 24.0,
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            TodoView(),
            CalendarView(),
          ],
        ),
      ),
    );
  }
}
