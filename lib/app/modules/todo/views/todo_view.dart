import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:todo_hive/app/utils/helpers/helpers.dart';
import 'package:todo_hive/app/utils/theme/app_color.dart';
import '../controllers/todo_controller.dart';

class TodoView extends GetView<TodoController> {
  final TodoController c = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return SingleChildScrollView(
          child: c.isChecked == true
              ? Text("")
              : Obx(() {
                  return ListView.builder(
                    itemCount: c.hasil.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: GestureDetector(
                          onTap: () => c.viewButton(index),
                          child: Slidable(
                            endActionPane:
                                ActionPane(motion: StretchMotion(), children: [
                              SlidableAction(
                                onPressed: (context) {
                                  c.deleteData(index);
                                },
                                icon: Icons.delete,
                                backgroundColor: AppColor.red,
                                borderRadius: AppHelper.cicularRadius,
                              )
                            ]),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: AppHelper.cicularRadius,
                                color: c.hasil[index].selesai == true
                                    ? Colors.grey[200]
                                    : AppColor.blue3,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      c.hasil[index].nama!,
                                    ),
                                    Checkbox(
                                        value: c.hasil[index].selesai,
                                        onChanged: (value) {
                                          c.checkBox(value, index);
                                        }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
        );
      }),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: const Icon(Icons.add),
        onPressed: () {
          c.addButton();
        },
      ),
    );
  }
}
