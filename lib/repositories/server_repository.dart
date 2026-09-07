import '../models/server_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ServerRepository {
  final ApiService apiService;
  final StorageService storageService;

  List<ServerModel> _cachedServers = [];

  ServerRepository({
    required this.apiService,
    required this.storageService,
  });

  Future<List<ServerModel>> getServers({bool forceRefresh = false}) async {
    if (_cachedServers.isNotEmpty && !forceRefresh) {
      return _applyFavorites(_cachedServers);
    }

    try {
      final remote = await apiService.fetchServers();
      _cachedServers = remote.isNotEmpty ? remote : ServerModel.sampleServers;
    } catch (_) {
      _cachedServers = ServerModel.sampleServers;
    }

    return _applyFavorites(_cachedServers);
  }

  List<ServerModel> _applyFavorites(List<ServerModel> servers) {
    final favorites = storageService.getFavoriteServers();
    return servers.map((s) => s.copyWith(isFavorite: favorites.contains(s.id))).toList();
  }

  Future<void> toggleFavorite(String serverId) async {
    await storageService.toggleFavoriteServer(serverId);
    _cachedServers = _applyFavorites(_cachedServers);
  }

  Future<ServerModel> getSelectedServer() async {
    final servers = await getServers();
    final savedId = storageService.getSelectedServerId();

    if (savedId != null) {
      final found = servers.where((s) => s.id == savedId).firstOrNull;
      if (found != null) return found;
    }

    // Default to fastest server (Kenya Nairobi or lowest ping)
    final sorted = List<ServerModel>.from(servers)..sort((a, b) => a.pingMs.compareTo(b.pingMs));
    final defaultServer = sorted.first;
    await storageService.saveSelectedServerId(defaultServer.id);
    return defaultServer;
  }

  Future<void> setSelectedServer(ServerModel server) async {
    await storageService.saveSelectedServerId(server.id);
  }
}
