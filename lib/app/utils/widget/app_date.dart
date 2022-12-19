import 'package:flutter/material.dart';
import 'package:todo_hive/app/utils/helpers/app_format.dart';
import 'package:todo_hive/app/utils/theme/theme.dart';

import '../helpers/helpers.dart';

class AppDateInput extends StatefulWidget {
  final TextEditingController textCon;
  final String? hintText;
  final bool? isEdit;
  final String label;

  const AppDateInput({
    Key? key,
    required this.textCon,
    required this.label,
    this.hintText,
    this.isEdit,
  });

  @override
  State<AppDateInput> createState() => _AppDateInputState();
}

class _AppDateInputState extends State<AppDateInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 15,
            ),
            Text(widget.label),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.only(left: 16),
          height: 50,
          decoration: BoxDecoration(
              borderRadius: AppHelper.cicularRadius,
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40000000),
                  offset: Offset(0, 1),
                  blurRadius: 4,
                  spreadRadius: 0,
                )
              ],
              color:
                  widget.isEdit == false ? Colors.grey[100] : AppColor.white),
          width: MediaQuery.of(context).size.width,
          child: TextField(
            onTap: () {
              if (widget.isEdit != true) {
                var now = DateTime.now();
                showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: DateTime(now.year - 3),
                        lastDate: DateTime(now.year + 3))
                    .then((value) {
                  setState(() {
                    widget.textCon.text = AppFormat.displayDate(value);
                  });
                });
              } else {}
            },
            controller: widget.textCon,
            readOnly: true,
            decoration: InputDecoration(
              enabled: widget.isEdit ?? true,
              border: InputBorder.none,
              hintText: widget.hintText,
              hintStyle: AppFont.input,
              suffixIcon: Icon(Icons.calendar_today),
            ),
          ),
        ),
      ],
    );
  }
}
