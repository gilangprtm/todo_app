import 'package:flutter/material.dart';
import 'package:todo_hive/app/utils/theme/theme.dart';

import '../helpers/helpers.dart';

class AppInputText extends StatelessWidget {
  final TextEditingController textCon;
  final String? hintText;
  final bool? isPassword;
  final bool? isDescription;
  final bool? isReadOnly;
  final String label;
  const AppInputText({
    Key? key,
    required this.textCon,
    required this.label,
    this.hintText,
    this.isPassword,
    this.isDescription,
    this.isReadOnly,
  });

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
            Text(label),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.only(left: 16),
          height: isDescription == true ? 100 : 50,
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
              color: isReadOnly == true ? Colors.grey[100] : AppColor.white),
          width: MediaQuery.of(context).size.width,
          child: TextField(
            maxLines: isDescription == true ? 4 : 1,
            controller: textCon,
            obscureText: isPassword ?? false,
            readOnly: isReadOnly ?? false,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: AppFont.input,
            ),
          ),
        ),
      ],
    );
  }
}
