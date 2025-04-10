import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme/app_color.dart';

class EmptyComponent extends StatelessWidget {
  final VoidCallback? onPressed;

  const EmptyComponent({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.boxOpen,
            size: 40,
            color: AppColors.black.withValues(alpha: .3),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          Text(
            "Tidak ada data",
            style: TextStyle(
              color: AppColors.black.withValues(alpha: .3),
            ),
          ),
          Visibility(
            visible: onPressed != null,
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(5)),
                TextButton(
                  onPressed: onPressed,
                  child: const Text(
                    "Refresh",
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
