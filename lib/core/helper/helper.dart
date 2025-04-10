import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'dialog_helper.dart';

class Helper {
  static void backOnPress({
    dynamic result,
    bool questionBack = true,
    bool editable = false,
    dynamic parametes,
  }) async {
    if (questionBack && editable) {
      final r = await DialogHelper.showConfirmationDialog(
        message: 'Anda yakin ingin kembali?',
      );
      if (r != true) return;
    }
    Navigator.of(context!).pop(result);
  }

  static String idGenerator() {
    const uuid = Uuid();
    var r = uuid.v4();
    return r;
  }
}
