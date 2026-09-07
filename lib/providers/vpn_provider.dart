import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/server_model.dart';
import '../models/traffic_stats_model.dart';
import '../models/vpn_state_model.dart';
import 'core_providers.dart';
import 'server_provider.dart';

final vpnStateStreamProvider = StreamProvider<VpnConnectionState>((ref) {
  final repo = ref.watch(vpnRepositoryProvider);
  return repo.vpnStateStream;
});

final trafficStatsStreamProvider = StreamProvider<TrafficStatsModel>((ref) {
  final repo = ref.watch(vpnRepositoryProvider);
  return repo.trafficStatsStream;
});

class VpnController extends StateNotifier<VpnConnectionState> {
  final Ref ref;
  StreamSubscription? _stateSub;
  Timer? _timer;
  int _secondsConnected = 0;

  VpnController(this.ref) : super(const VpnConnectionState()) {
    final repo = ref.read(vpnRepositoryProvider);
    state = repo.currentState;

    _stateSub = repo.vpnStateStream.listen((newState) {
      state = newState;
      if (newState.status == VpnStatus.connected) {
        _startTimer();
      } else if (newState.status == VpnStatus.disconnected) {
        _stopTimer();
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsConnected = 0;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _secondsConnected++;
      // Trigger subtle rebuild for duration updates
      if (mounted) {
        state = state.copyWith();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    _secondsConnected = 0;
  }

  Duration get currentDuration => Duration(seconds: _secondsConnected);

  Future<void> toggleConnection() async {
    final selectedServer = ref.read(selectedServerProvider);
    if (selectedServer == null) return;

    if (state.status == VpnStatus.connected || state.status == VpnStatus.connecting) {
      await disconnect();
    } else {
      await connect(selectedServer);
    }
  }

  Future<void> connect(ServerModel server) async {
    await ref.read(vpnRepositoryProvider).connect(server);
  }

  Future<void> disconnect() async {
    await ref.read(vpnRepositoryProvider).disconnect();
  }

  Future<void> reconnect(ServerModel server) async {
    await ref.read(vpnRepositoryProvider).reconnect(server);
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}

final vpnControllerProvider = StateNotifierProvider<VpnController, VpnConnectionState>((ref) {
  return VpnController(ref);
});

// Periodic connection duration provider
final vpnDurationProvider = StreamProvider.autoDispose<Duration>((ref) async* {
  final vpnState = ref.watch(vpnControllerProvider);
  if (vpnState.status != VpnStatus.connected || vpnState.connectedAt == null) {
    yield Duration.zero;
    return;
  }

  final connectedAt = vpnState.connectedAt!;
  yield DateTime.now().difference(connectedAt);

  final ticker = Stream.periodic(const Duration(seconds: 1), (_) {
    return DateTime.now().difference(connectedAt);
  });

  yield* ticker;
});
