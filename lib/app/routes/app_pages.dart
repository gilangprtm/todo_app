import 'package:get/get.dart';

import 'package:todo_hive/app/modules/add_todo/bindings/add_todo_binding.dart';
import 'package:todo_hive/app/modules/add_todo/views/add_todo_view.dart';
import 'package:todo_hive/app/modules/calendar/bindings/calendar_binding.dart';
import 'package:todo_hive/app/modules/calendar/views/calendar_view.dart';
import 'package:todo_hive/app/modules/home/bindings/home_binding.dart';
import 'package:todo_hive/app/modules/home/views/home_view.dart';
import 'package:todo_hive/app/modules/todo/bindings/todo_binding.dart';
import 'package:todo_hive/app/modules/todo/views/todo_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TODO,
      page: () => TodoView(),
      binding: TodoBinding(),
    ),
    GetPage(
      name: _Paths.CALENDAR,
      page: () => CalendarView(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: _Paths.ADD_TODO,
      page: () => AddTodoView(),
      binding: AddTodoBinding(),
    ),
  ];
}
