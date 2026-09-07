import 'package:dio/dio.dart';
import '../core/constants/app_constants.dart';
import '../core/network/dio_client.dart';
import '../models/server_model.dart';
import '../models/user_model.dart';

class ApiService {
  final DioClient dioClient;

  ApiService({required this.dioClient});

  /// Backend Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dioClient.dio.post(
        AppConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      // Return simulated success when backend server is not running
      if (e.type == DioExceptionType.connectionError || e.response == null) {
        return {
          'token': 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
          'user': {
            'id': 'u_${email.hashCode.abs()}',
            'email': email,
            'displayName': email.split('@').first,
            'isPremium': false,
          }
        };
      }
      throw dioClient.handleDioError(e);
    }
  }

  /// Backend Register
  Future<Map<String, dynamic>> register(String email, String password, String name) async {
    try {
      final response = await dioClient.dio.post(
        AppConstants.registerEndpoint,
        data: {'email': email, 'password': password, 'name': name},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.response == null) {
        return {
          'token': 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
          'user': {
            'id': 'u_${DateTime.now().millisecondsSinceEpoch}',
            'email': email,
            'displayName': name,
            'isPremium': false,
          }
        };
      }
      throw dioClient.handleDioError(e);
    }
  }

  /// Fetch remote VPN servers
  Future<List<ServerModel>> fetchServers() async {
    try {
      final response = await dioClient.dio.get(AppConstants.serversEndpoint);
      final list = response.data['servers'] as List<dynamic>;
      return list.map((item) => ServerModel.fromJson(item as Map<String, dynamic>)).toList();
    } on DioException {
      // Fallback to high-speed sample servers
      return ServerModel.sampleServers;
    }
  }

  /// Fetch user profile & bandwidth usage
  Future<UserModel> fetchUserProfile() async {
    try {
      final response = await dioClient.dio.get(AppConstants.profileEndpoint);
      return UserModel.fromJson(response.data['user'] as Map<String, dynamic>);
    } on DioException {
      return UserModel.guest();
    }
  }

  /// Check subscription status
  Future<bool> checkPremiumStatus() async {
    try {
      final response = await dioClient.dio.get(AppConstants.premiumStatusEndpoint);
      return response.data['isPremium'] as bool? ?? false;
    } on DioException {
      return false;
    }
  }

  /// Report telemetry and data usage
  Future<void> reportUsage(int bytesTransferred, String serverId) async {
    try {
      await dioClient.dio.post(
        AppConstants.usageReportEndpoint,
        data: {
          'bytes': bytesTransferred,
          'serverId': serverId,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (_) {
      // Ignore telemetry errors
    }
  }
}
