import 'dart:convert';
// import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../core/mahas/mahas_config.dart';
import '../../../../core/mahas/models/api_result_model.dart';

class HttpApi {
  static String? _apiToken;
  static DateTime _apiTokenExpired = DateTime.now();

  static void clearToken() {
    _apiToken = null;
  }

  static Future<String?> _token() async {
    var now = DateTime.now();
    if (_apiToken == null || _apiTokenExpired.isBefore(now)) {
      _apiTokenExpired = DateTime(
          now.year, now.month, now.day, now.hour, now.minute + 59, now.second);
      _apiToken = "";
    }
    return _apiToken;
  }

  static String getUrl(String url) {
    if (url.toUpperCase().contains('HTTPS://') ||
        url.toUpperCase().contains('HTTP://')) {
      return url;
    } else {
      return MahasConfig.urlApi + url;
    }
  }

  static ApiResultModel _getResult(http.Response r) {
    // print(r.body);
    // print(r.statusCode);
    // print(r.request!.url);
    // print(r.request!.method);
    return ApiResultModel(r.statusCode, r.body);
  }

  static ApiResultModel _getErrorResult(dynamic ex) {
    _apiToken = null;
    String errorString = "";
    for (var e in MahasConfig.noInternetErrorMessage) {
      if (ex.toString().contains(RegExp(e, caseSensitive: false))) {
        errorString = "Gagal memuat data, silahkan cek koneksi internet";
        break;
      } else {
        errorString = "$ex";
      }
    }
    return ApiResultModel.error(errorString);
  }

  static Future<ApiResultModel> get(String url) async {
    try {
      final token = await _token();
      // log(token!);
      final urlX = Uri.parse(getUrl(url));
      final r = await http.get(
        urlX,
        headers: {
          'Authorization': token != null ? 'Bearer $token' : '',
        },
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          return http.Response(
              'Error Request Timeout\nCek koneksi internet Anda dan coba beberapa saat lagi!',
              408);
        },
      );

      return _getResult(r);
    } catch (ex) {
      return _getErrorResult(ex);
    }
  }

  static Future<ApiResultModel> post(String url, {Object? body}) async {
    try {
      final token = await _token();
      final urlX = Uri.parse(getUrl(url));
      var r = await http
          .post(
        urlX,
        headers: {
          'Content-type': 'application/json',
          'Authorization': token != null ? 'Bearer $token' : '',
        },
        body: json.encode(body),
      )
          .timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          return http.Response(
              'Error Request Timeout\nCek koneksi internet Anda dan coba beberapa saat lagi!',
              408);
        },
      );
      return _getResult(r);
    } catch (ex) {
      return _getErrorResult(ex);
    }
  }

  static Future<ApiResultModel> put(String url, {Object? body}) async {
    try {
      final token = await _token();
      final urlX = Uri.parse(getUrl(url));
      var r = await http
          .put(
        urlX,
        headers: {
          'Content-type': 'application/json',
          'Authorization': token != null ? 'Bearer $token' : '',
        },
        body: json.encode(body),
      )
          .timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          return http.Response(
              'Error Request Timeout\nCek koneksi internet Anda dan coba beberapa saat lagi!',
              408);
        },
      );
      return _getResult(r);
    } catch (ex) {
      return _getErrorResult(ex);
    }
  }

  static Future<ApiResultModel> delete(String url, {Object? body}) async {
    try {
      final token = await _token();
      final urlX = Uri.parse(getUrl(url));
      var r = await http
          .delete(
        urlX,
        headers: {
          'Content-type': 'application/json',
          'Authorization': token != null ? 'Bearer $token' : '',
        },
        body: json.encode(body),
      )
          .timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          return http.Response(
              'Error Request Timeout\nCek koneksi internet Anda dan coba beberapa saat lagi!',
              408);
        },
      );
      return _getResult(r);
    } catch (ex) {
      return _getErrorResult(ex);
    }
  }
}
