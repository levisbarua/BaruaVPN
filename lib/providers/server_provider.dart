import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/server_model.dart';
import 'core_providers.dart';

final serverListProvider = FutureProvider<List<ServerModel>>((ref) async {
  final repo = ref.watch(serverRepositoryProvider);
  return repo.getServers();
});

final selectedServerProvider = StateNotifierProvider<SelectedServerNotifier, ServerModel?>((ref) {
  return SelectedServerNotifier(ref);
});

class SelectedServerNotifier extends StateNotifier<ServerModel?> {
  final Ref ref;

  SelectedServerNotifier(this.ref) : super(null) {
    _loadSelected();
  }

  Future<void> _loadSelected() async {
    final repo = ref.read(serverRepositoryProvider);
    final server = await repo.getSelectedServer();
    state = server;
  }

  Future<void> selectServer(ServerModel server) async {
    state = server;
    await ref.read(serverRepositoryProvider).setSelectedServer(server);
  }
}

// Server Filters & Search
enum ServerTabFilter { all, recommended, free, premium }

final serverTabFilterProvider = StateProvider<ServerTabFilter>((ref) => ServerTabFilter.all);
final serverSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredServersProvider = Provider<List<ServerModel>>((ref) {
  final serversAsync = ref.watch(serverListProvider);
  final query = ref.watch(serverSearchQueryProvider).toLowerCase();
  final filter = ref.watch(serverTabFilterProvider);

  return serversAsync.maybeWhen(
    data: (servers) {
      return servers.where((s) {
        // Tab filter
        if (filter == ServerTabFilter.free && s.isPremium) return false;
        if (filter == ServerTabFilter.premium && !s.isPremium) return false;
        if (filter == ServerTabFilter.recommended && s.pingMs > 95) return false;

        // Search query
        if (query.isNotEmpty) {
          final matchesCountry = s.country.toLowerCase().contains(query);
          final matchesCity = s.city.toLowerCase().contains(query);
          final matchesName = s.name.toLowerCase().contains(query);
          return matchesCountry || matchesCity || matchesName;
        }

        return true;
      }).toList();
    },
    orElse: () => [],
  );
});
