import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../../../core/helper/dialog_helper.dart';

enum UrlType {
  baseUrl,
  customUrl, // For handling complete URLs
}

class DioService {
  final Dio _dio;

  static String getBaseUrl(UrlType urlType) {
    switch (urlType) {
      case UrlType.baseUrl:
        return "https://pokeapi.co/api/v2";
      case UrlType.customUrl:
        return ""; // Empty string as we'll use the full path for custom URLs
    }
  }

  DioService() : _dio = Dio() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    );

    _dio.interceptors.addAll([
      PrettyDioLogger(
        request: false,
        // requestHeader: true,
        // requestBody: true,
        // responseHeader: true,
        responseBody: false,
        // error: true,
        // compact: true,
      ),
      _TokenInterceptor(),
    ]);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    UrlType urlType = UrlType.baseUrl,
    bool isFullUrl = false, // Flag to indicate if path is a complete URL
  }) async {
    // If isFullUrl is true, use the path as is, otherwise combine with base URL
    var url = isFullUrl ? path : getBaseUrl(urlType) + path;

    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
      );

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    UrlType urlType = UrlType.baseUrl,
    bool isFullUrl = false,
  }) async {
    try {
      // If isFullUrl is true, use the path as is, otherwise combine with base URL
      var url = isFullUrl ? path : getBaseUrl(urlType) + path;

      final response = await _dio.post(url,
          data: data, queryParameters: queryParameters, options: options);

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    UrlType urlType = UrlType.baseUrl,
    bool isFullUrl = false,
  }) async {
    try {
      // If isFullUrl is true, use the path as is, otherwise combine with base URL
      var url = isFullUrl ? path : getBaseUrl(urlType) + path;

      final response = await _dio.put(url,
          data: data, queryParameters: queryParameters, options: options);

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    UrlType urlType = UrlType.baseUrl,
    bool isFullUrl = false,
  }) async {
    try {
      // If isFullUrl is true, use the path as is, otherwise combine with base URL
      var url = isFullUrl ? path : getBaseUrl(urlType) + path;

      final response = await _dio.patch(url,
          data: data, queryParameters: queryParameters, options: options);

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    UrlType urlType = UrlType.baseUrl,
    bool isFullUrl = false,
  }) async {
    try {
      // If isFullUrl is true, use the path as is, otherwise combine with base URL
      var url = isFullUrl ? path : getBaseUrl(urlType) + path;

      final response = await _dio.delete(url,
          queryParameters: queryParameters, options: options);

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> postFormData(
    String path,
    FormData formData, {
    UrlType urlType = UrlType.baseUrl,
    bool isFullUrl = false,
  }) async {
    try {
      // If isFullUrl is true, use the path as is, otherwise combine with base URL
      var url = isFullUrl ? path : getBaseUrl(urlType) + path;

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> putFormData(
    String path,
    FormData formData, {
    UrlType urlType = UrlType.baseUrl,
    bool isFullUrl = false,
  }) async {
    try {
      // If isFullUrl is true, use the path as is, otherwise combine with base URL
      var url = isFullUrl ? path : getBaseUrl(urlType) + path;

      final response = await _dio.put(
        url,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> patchFormData(
    String path,
    FormData formData, {
    UrlType urlType = UrlType.baseUrl,
    bool isFullUrl = false,
  }) async {
    try {
      // If isFullUrl is true, use the path as is, otherwise combine with base URL
      var url = isFullUrl ? path : getBaseUrl(urlType) + path;

      final response = await _dio.patch(
        url,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Updated error handling with DioException
  DioException _handleError(dynamic error) {
    if (error is DioException) {
      String message = 'Unknown error occurred.';
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'Connection timeout, please try again later.';
          break;

        case DioExceptionType.badResponse:
          message =
              'Bad response from server, status code: ${error.response?.statusCode}';
          break;

        // DioExceptionType.cancel is no longer directly available
        case DioExceptionType.cancel:
          message = 'Request to API server was cancelled.';
          break;

        // DioExceptionType.other has been replaced with a generic error type
        case DioExceptionType.connectionError:
          message = 'Check your internet, and try again later.';
          break;

        // Handle unknown types
        default:
          message = 'An unknown error occurred';
          break;
      }
      DialogHelper.showErrorDialog(
        message,
      );
      return DioException(
        requestOptions: error.requestOptions,
        error: message,
      );
    } else {
      return DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'Unknown error occurred.');
    }
  }
}

class _TokenInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Add token to the header before the request is sent
    String? token = await _getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Handle token refresh logic here
      String? newToken = await _refreshToken();
      if (newToken != null) {
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        final cloneReq = await Dio().fetch(err.requestOptions);
        return handler.resolve(cloneReq);
      }
    }
    handler.next(err);
  }

  Future<String?> _getToken() async {
    // Fetch the token from local storage or secure storage
    return 'your-token';
  }

  Future<String?> _refreshToken() async {
    // Implement refresh token logic
    return 'new-token';
  }
}
