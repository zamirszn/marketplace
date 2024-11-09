import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:marketplace/core/constants/constant.dart';
import 'package:marketplace/core/network/dio_client.dart';
import 'package:marketplace/data/source/secure_storage_data_source.dart';
import 'package:marketplace/domain/usecases/auth_usecase.dart';
import 'package:marketplace/presentation/service_locator.dart';

class LoggerInterceptor extends Interceptor {
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: true),
  );

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final requestPath =
        "${err.requestOptions.baseUrl}${err.requestOptions.path}";

    // Check if the error status is 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      logger.w("Access token expired. Attempting to refresh...");

      final refreshTokenResult =
          await sl<SecureStorageDataSource>().read(Constant.refreshToken);

      // Check if refresh token retrieval was successful
      return refreshTokenResult.fold(
        (error) {
          logger.e("Failed to retrieve refresh token: $error");
          handler.next(err); // Pass the error along if refresh token is missing
        },
        (refreshToken) async {
          // Call the use case to refresh the access token
          final refreshResult =
              await sl<RefreshTokenUsecase>().call(params: refreshToken);

          return refreshResult.fold(
            (refreshError) {
              logger.e("Token refresh failed: $refreshError");
              handler.next(err); // Pass the original error if refresh fails
            },
            (data) async {
              final String newAccessToken = data[Constant.accessToken];
              // Save the new access token in secure storage

              await sl<SecureStorageDataSource>()
                  .write(Constant.accessToken, newAccessToken);
              logger
                  .i("Token refresh successful. Retrying original request...");

              // Retry the original request with the new access token
              final retryOptions = err.requestOptions;
              retryOptions.headers[authorization] = 'JWT $newAccessToken';

              try {
                final response = await Dio().fetch(retryOptions);
                handler.resolve(response); // Return successful response
              } catch (retryError) {
                handler.reject(retryError
                    as DioException); // Handle retry error if it occurs
              }
            },
          );
        },
      );
    } else {
      // Log and pass through any errors that aren’t 401 Unauthorized
      logger.e("${err.requestOptions.method} request ==> $requestPath");
      logger.d("Error type: ${err.error} \nError message: ${err.message}");
      handler.next(err);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = "${options.baseUrl}${options.path}";
    logger.i("${options.method} request ==> $requestPath");
    handler.next(options); // continue with the Request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d(
      'STATUSCODE: ${response.statusCode} \n '
      'STATUSMESSAGE: ${response.statusMessage} \n'
      'HEADERS: ${response.headers} \n'
      'Data: ${response.data}',
    );
    handler.next(response);
  }
}
