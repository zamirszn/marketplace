import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:marketplace/data/network/api_response_status.dart';
import 'package:marketplace/data/network/app_exception.dart';
import 'package:marketplace/data/network/dio_factory.dart';

class BaseClient {
  Future<dynamic>? getRequest({
    required String endpoint,
  }) async {
    try {
      Response response = await dioObj.get(endpoint);
      if (kDebugMode) {
        print(response);
      }
      return _processResponse(response);
    } on DioException catch (e) {
      return handleException(e);
    }
  }

  Future<dynamic>? deleteRequest({
    required String endpoint,
    required Map<String, dynamic> payload,
    Options? options,
  }) async {
    // FormData payloadData = FormData.fromMap(payload);
    try {
      Response response = await dioObj.delete(
        endpoint,
        data: payload,
      );
      if (kDebugMode) {
        print(response);
      }

      return _processResponse(response);
    } on DioException catch (e) {
      return handleException(e);
    }
  }

  Future<Object>? postRequest({
    required String endpoint,
    required Object payload,
  }) async {
    try {
      Response response = await dioObj.post(endpoint, data: payload);
      if (kDebugMode) {
        print(response);
      }

      return _processResponse(response);
    } on DioException catch (e) {
      return handleException(e);
    }
  }

  Future<Object>? putRequest({
    required String endpoint,
    required Object payload,
  }) async {
    try {
      Response response = await dioObj.put(endpoint, data: payload);

      return _processResponse(response);
    } on DioException catch (e) {
      return handleException(e);
    }
  }

  dynamic _processResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return Success(
          code: response.statusCode,
          responseData: response.data,
        );
      case 201:
        return Success(
          code: response.statusCode,
          responseData: response.data,
        );
      case 302:
        return Success(
          code: response.statusCode,
          responseData: response.data,
        );

      case 401:
        return Failure(
          code: response.statusCode,
          message: response.data["message"] ?? unAuthorizedRequest,
        );
      case 404:
        return Failure(
          code: response.statusCode,
          message: response.data["message"] ?? notFound,
        );

      case 400:
        return Failure(
          code: response.statusCode,
          message: response.data["message"] ?? badRequest,
        );
      case 500:
        return Failure(
          code: response.statusCode,
          message: response.data["message"] ?? serverError,
        );
      case 204:
        return Failure(
          code: response.statusCode,
          message: response.data,
        );

      default:
        return Failure(
          code: response.statusCode,
          message: response.data["message"] ?? unknownError,
        );
    }
  }

  Failure handleException(DioException e) {
    if (kDebugMode) {
      print(e);
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Failure(code: 101, message: requestTimeout);
    } else if (e.type == DioExceptionType.connectionError) {
      return Failure(code: 100, message: noInternetConnection);
    } else if (e.type == DioExceptionType.unknown) {
      return Failure(code: 500, message: unknownError);
    } else {
      return Failure(code: 500, message: somethingWentWrong);
    }
  }
}

final BaseClient baseClient = BaseClient();
