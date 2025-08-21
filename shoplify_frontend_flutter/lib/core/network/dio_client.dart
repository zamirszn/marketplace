import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shoplify/core/constants/api_urls.dart';
import 'package:shoplify/core/network/interceptor.dart';
import 'package:shoplify/presentation/resources/string_manager.dart';

const String applicationJson = "application/json";
const String contentType = "content-type";
const String accept = "accept";
const String authorization = "Authorization";
const String defaultLanguage = "language";
Duration timeOut = const Duration(seconds: 30);

class DioClient {
  late final Dio _dio;
  String? _authToken;

  DioClient()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiUrls.baseUrl,
          headers: {
            contentType: applicationJson,
          },
          validateStatus: (status) =>
              status != null && status >= 200 && status < 400,
          responseType: ResponseType.json,
          sendTimeout: timeOut,
          receiveTimeout: timeOut,
        ))
          ..interceptors.addAll([LoggerInterceptor()]);

  Options _getOptions(Options? options) {
    options ??= Options();
    if (_authToken != null) {
      options.headers ??= {};
      options.headers![authorization] = 'JWT $_authToken';
    }
    return options;
  }

  void setAuthToken(String token) {
    _authToken = token;
    _dio.options.headers[authorization] = 'JWT $token';
  }

  void clearAuthToken() {
    _authToken = null;
    _dio.options.headers.remove(authorization);
  }

  Future<Response> fetch(RequestOptions options) async {
    return await _dio.fetch(options);
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: _getOptions(options),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: _getOptions(options),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: _getOptions(options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

    Future<Response> patch(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: _getOptions(options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: _getOptions(options),
        cancelToken: cancelToken,
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Response processor
  dynamic _processResponse(Response response) {
    if (response.statusCode != null &&
        response.statusCode! >= 200 &&
        response.statusCode! < 300) {
      // Return successful response
      return response;
    } else if (response.statusCode != null &&
        response.statusCode! >= 400 &&
        response.statusCode! < 500) {
      // Client-side error
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: _formatErrorMessages(response),
      );
    } else if (response.statusCode != null && response.statusCode! >= 500) {
      // Server-side error
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Server error: ${response.statusCode}',
      );
    } else {
      // Unknown error
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: 'Unknown error occurred.',
      );
    }
  }

  // Error formatting
  String _formatErrorMessages(Response response) {
    // Handle specific error response structures
    if (response.data is Map<String, dynamic>) {
      StringBuffer errorMessage = StringBuffer();

      response.data.forEach((key, value) {
        if (value is List) {
          for (var msg in value) {
            if (value.length < 2) {
              errorMessage.write('$msg');
            } else {
              errorMessage.writeln('$msg');
            }
          }
        } else {
          errorMessage.write('$value');
        }
      });

      return errorMessage.toString();
    } else {
      return response.statusMessage ?? 'Unknown error';
    }
  }

  // Handle Dio errors centrally
  _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      return _formatErrorMessages(e.response!);
    }

    if (e.error is HttpException) {
      return AppStrings.connectionError;
    }

    if (e.type == DioExceptionType.connectionError) {
      return AppStrings.connectionError;
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return AppStrings.connectionTimedOut;
    }

    return AppStrings.somethingWentWrong;
  }
}
