import 'package:todo_hive/app/utils/helpers/app_format.dart';

class TodoModel {
  TodoModel({
    this.nama,
    this.selesai,
    this.deskripsi,
    this.tanggal,
  });

  String? nama;
  String? deskripsi;
  bool? selesai;
  DateTime? tanggal;

  static TodoModel fromDynamic(dynamic json) => TodoModel(
        nama: json["nama"],
        deskripsi: json["deskripsi"],
        selesai: json["selesai"],
        tanggal: AppFormat.stringToDateTime(json["tanggal"]),
      );
}
