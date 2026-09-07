import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../errors/app_exception.dart';
import '../../services/storage_service.dart';

class DioClient {
  late final Dio dio;
  final StorageService storageService;

  DioClient({required this.storageService}) {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseApiUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Client-Version': AppConstants.appVersion,
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attach auth token if available
          final token = await storageService.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Token expired; attempt token refresh or clear session
            await storageService.clearToken();
          }
          return handler.next(e);
        },
      ),
    );
  }

  AppException handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timed out. Please check your internet connection.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        final msg = data is Map ? data['message'] ?? 'Server error' : 'Server error ($statusCode)';
        return NetworkException(msg.toString(), code: statusCode.toString());
      case DioExceptionType.cancel:
        return const NetworkException('Request cancelled.');
      default:
        return NetworkException(error.message ?? 'Unexpected network error occurred.');
    }
  }
}
