import 'package:get/get.dart';

class AppTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': {
          'add_todo_title': 'Add Your ToDo',
          'title': 'Title',
          'description': 'Description',
          'date': 'Date',
          'save': 'Save',
          'locale': 'en_US'
        },
        'id': {
          'add_todo_title': 'Tambahkan ToDo',
          'title': 'Judul',
          'description': 'Deskripsi',
          'date': 'Tanggal',
          'save': 'Simpan',
          'locale': 'id_ID'
        },
      };
}
