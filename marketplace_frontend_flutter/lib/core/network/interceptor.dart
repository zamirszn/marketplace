import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:marketplace/core/constants/constant.dart';
import 'package:marketplace/core/network/dio_client.dart';
import 'package:marketplace/data/source/secure_storage_data_source.dart';
import 'package:marketplace/domain/usecases/auth_usecase.dart';
import 'package:marketplace/presentation/service_locator.dart';

class LoggerInterceptor extends Interceptor {
  final Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: true),
  );

  bool _isRefreshing = false; // Flag to track if refresh is in progress
  List<Function> _pendingRequests = []; // Queue to hold pending requests

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final requestPath =
        "${err.requestOptions.baseUrl}${err.requestOptions.path}";

    // Check if the error status is 401 (Unauthorized)
    if (err.response?.statusCode == 401) {
      _pendingRequests.add(() => _retryRequest(err, handler));

      if (_isRefreshing) {
        return;
      }

      _isRefreshing = true;

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
          final refreshResultRequest =
              await sl<RefreshTokenUsecase>().call(params: refreshToken);

          // Call the use case to refresh the access token

          refreshResultRequest.fold(
            (refreshError) {
              logger.e("Token refresh failed: $refreshError");
              _isRefreshing = false; // Reset the flag
              handler.next(err); // Pass the original error if refresh fails
            },
            (data) async {
              final String newAccessToken = data[Constant.accessToken];

              // Save the new access token in secure storage
              await sl<SecureStorageDataSource>()
                  .write(Constant.accessToken, newAccessToken);
              logger
                  .i("Token refresh successful. Retrying original request...");

              // Retry all pending requests with the new access token
              _retryPendingRequests();
              _isRefreshing = false; // Reset the flag
              _pendingRequests.clear(); // Clear the queue
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

  // Helper function to retry a single request
  Future<void> _retryRequest(
      DioException err, ErrorInterceptorHandler handler) async {
    final dio = sl<DioClient>();
    final retryOptions = err.requestOptions;
    final newAccessTokenFromStorage = await sl<SecureStorageDataSource>()
        .read(Constant.accessToken); // Read the new token from storage

    newAccessTokenFromStorage.fold((error) {
      handler.next(err);
    }, (token) async {
      retryOptions.headers[authorization] = 'JWT $token';

      try {
        final response = await dio.fetch(retryOptions);
        handler.resolve(response); // Return successful response
      } catch (retryError) {
        handler.reject(
            retryError as DioException); // Handle retry error if it occurs
      }
    });
  }

  // Helper function to retry all pending requests with the new access token
  void _retryPendingRequests() {
    _pendingRequests.forEach((callback) {
      callback();
    });
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = "${options.baseUrl}${options.path}";
    logger.i("${options.method} request ==> $requestPath");
    handler.next(options); // continue with the Request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // logger.d(
    //   'STATUSCODE: ${response.statusCode} \n '
    //   'STATUSMESSAGE: ${response.statusMessage} \n'
    //   'HEADERS: ${response.headers} \n'
    //   'Data: ${response.data}',
    // );
    handler.next(response);
  }
}
