import 'server_model.dart';

enum VpnStatus {
  disconnected,
  connecting,
  connected,
  disconnecting,
  error;

  bool get isConnected => this == VpnStatus.connected;
  bool get isConnecting => this == VpnStatus.connecting;
  bool get isDisconnected => this == VpnStatus.disconnected;
  bool get isDisconnecting => this == VpnStatus.disconnecting;
  bool get isError => this == VpnStatus.error;

  String get label {
    switch (this) {
      case VpnStatus.disconnected:
        return 'Disconnected';
      case VpnStatus.connecting:
        return 'Connecting...';
      case VpnStatus.connected:
        return 'Connected • Protected';
      case VpnStatus.disconnecting:
        return 'Disconnecting...';
      case VpnStatus.error:
        return 'Connection Failed';
    }
  }
}

class VpnConnectionState {
  final VpnStatus status;
  final ServerModel? activeServer;
  final DateTime? connectedAt;
  final String? errorMessage;

  const VpnConnectionState({
    this.status = VpnStatus.disconnected,
    this.activeServer,
    this.connectedAt,
    this.errorMessage,
  });

  Duration get connectionDuration {
    if (connectedAt == null || status != VpnStatus.connected) {
      return Duration.zero;
    }
    return DateTime.now().difference(connectedAt!);
  }

  VpnConnectionState copyWith({
    VpnStatus? status,
    ServerModel? activeServer,
    DateTime? connectedAt,
    String? errorMessage,
    bool clearServer = false,
  }) {
    return VpnConnectionState(
      status: status ?? this.status,
      activeServer: clearServer ? null : (activeServer ?? this.activeServer),
      connectedAt: connectedAt ?? this.connectedAt,
      errorMessage: errorMessage,
    );
  }
}
