import 'package:dart_ping/dart_ping.dart';

void main() async {
  final ping = Ping('1.1.1.1', count: 3);
  await for (final event in ping.stream) {
    if (event.response != null) {
      print(event.response!.time?.inMilliseconds);
    }
  }
}
