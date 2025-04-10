class ApiResultModel {
  bool success = true;
  dynamic body;
  String? message;
  int? statusCode;

  ApiResultModel(this.statusCode, this.body) {
    if (statusCode == 200) {
      success = true;
    } else if (statusCode == 400) {
      success = false;
      message = body;
    } else {
      success = false;
      if (statusCode == 500) {
        message = "Internal Server Error";
      } else if (body is String) {
        message = body;
        if (message!.indexOf('<!DOCTYPE html>') == 0) {
          var start = message!.indexOf('<title>') + '<title>'.length;
          var end = message!.indexOf('</title>');
          message = message!.substring(start, end);
        } else {}
      } else {
        message = body.toString();
      }
    }
  }

  ApiResultModel.error(this.message, {this.success = false});
}
