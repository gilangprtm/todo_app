import 'package:flutter/material.dart';

import '../../theme/app_color.dart';
import '../mahas_type.dart';

// Define MahasTile
class MahasTile extends StatelessWidget {
  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final bool isThreeLine;
  final Function()? onTap;
  final BorderRadius borderRadius;
  final Color? backgroundColor;

  const MahasTile({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.isThreeLine = false,
    this.onTap,
    this.borderRadius = MahasBorderRadius.medium,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.white,
          borderRadius: borderRadius,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (leading != null) leading!,
            if (leading != null) const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) title!,
                  if (subtitle != null) ...[
                    const SizedBox(height: 4.0),
                    subtitle!,
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
