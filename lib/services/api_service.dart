import 'package:dio/dio.dart';
import '../core/constants/app_constants.dart';
import '../core/network/dio_client.dart';
import '../models/server_model.dart';

class ApiService {
  final DioClient dioClient;

  ApiService({required this.dioClient});

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
