import 'package:flutter/material.dart';
import 'package:todo_hive/app/utils/helpers/helpers.dart';
import 'package:todo_hive/app/utils/theme/app_color.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final double? borderRadius;
  const AppButton({required this.text, required this.onTap, this.borderRadius});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: AppHelper.cicularRadius,
          ),
        ),
      ),
    );
  }
}
