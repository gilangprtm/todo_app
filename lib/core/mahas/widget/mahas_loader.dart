import 'package:flutter/material.dart';

class MahasLoader extends StatelessWidget {
  final bool isLoading;

  const MahasLoader({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container();
  }
}
