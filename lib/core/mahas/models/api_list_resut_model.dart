import 'dart:convert';
import '../mahas_config.dart';

class ApiResultListModel {
  int? totalRowCount;
  int? limit;
  int? maxPage;
  List<dynamic>? datas;

  static fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static ApiResultListModel fromDynamic(dynamic data) {
    final model = ApiResultListModel();
    if (MahasConfig.isLaravelBackend) {
      model.totalRowCount = data['totalRowCount'];
      model.limit = data['data']['per_page'];
      model.datas = data['data']['data'];
    } else {
      model.totalRowCount = data['totalCount'];
      model.limit = data['pageSize'];
      model.datas = data['datas'];
    }
    model.maxPage = model.totalRowCount == 0
        ? 0
        : (model.totalRowCount! / model.limit!).ceil() - 1;
    return model;
  }
}
