class LanguangeModel {
  LanguangeModel({
    this.bahasa,
    this.code,
  });

  String? bahasa;
  String? code;

  static LanguangeModel fromDynamic(dynamic json) => LanguangeModel(
        bahasa: json["bahasa"],
        code: json["code"],
      );
}
