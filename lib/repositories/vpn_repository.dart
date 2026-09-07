import 'dart:async';
import '../models/server_model.dart';
import '../models/traffic_stats_model.dart';
import '../models/vpn_state_model.dart';
import '../services/vpn_service.dart';
import '../services/storage_service.dart';

class VpnRepository {
  final VpnService vpnService;
  final StorageService storageService;

  final _vpnStateController = StreamController<VpnConnectionState>.broadcast();
  VpnConnectionState _currentState = const VpnConnectionState();
  StreamSubscription? _statusSubscription;
  StreamSubscription? _trafficSubscription;

  VpnRepository({
    required this.vpnService,
    required this.storageService,
  }) {
    _init();
  }

  VpnConnectionState get currentState => _currentState;
  Stream<VpnConnectionState> get vpnStateStream => _vpnStateController.stream;
  Stream<TrafficStatsModel> get trafficStatsStream => vpnService.trafficStatsStream;

  void _init() {
    vpnService.initialize();

    _statusSubscription = vpnService.statusStream.listen((status) {
      DateTime? connectedAt = _currentState.connectedAt;
      if (status == VpnStatus.connected && connectedAt == null) {
        connectedAt = DateTime.now();
      } else if (status == VpnStatus.disconnected) {
        connectedAt = null;
      }

      _currentState = _currentState.copyWith(
        status: status,
        connectedAt: connectedAt,
      );
      _vpnStateController.add(_currentState);
    });

    _trafficSubscription = vpnService.trafficStatsStream.listen((stats) {
      if (_currentState.status == VpnStatus.connected && stats.totalBytes > 0) {
        // Track daily usage
        storageService.addDailyUsageBytes(stats.downloadSpeedBytesPerSec.toInt() + stats.uploadSpeedBytesPerSec.toInt());
      }
    });
  }

  Future<void> connect(ServerModel server) async {
    _currentState = _currentState.copyWith(
      status: VpnStatus.connecting,
      activeServer: server,
    );
    _vpnStateController.add(_currentState);
    await vpnService.connect(server);
  }

  Future<void> disconnect() async {
    _currentState = _currentState.copyWith(
      status: VpnStatus.disconnecting,
    );
    _vpnStateController.add(_currentState);
    await vpnService.disconnect();
  }

  Future<void> reconnect(ServerModel server) async {
    _currentState = _currentState.copyWith(
      status: VpnStatus.connecting,
      activeServer: server,
    );
    _vpnStateController.add(_currentState);
    await vpnService.reconnect(server);
  }

  void dispose() {
    _statusSubscription?.cancel();
    _trafficSubscription?.cancel();
    _vpnStateController.close();
    vpnService.dispose();
  }
}
