import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/speed_test_model.dart';
import 'core_providers.dart';

class SpeedTestNotifier extends StateNotifier<SpeedTestResult> {
  final Ref ref;
  StreamSubscription? _testSub;

  SpeedTestNotifier(this.ref) : super(const SpeedTestResult());

  void startTest() {
    _testSub?.cancel();
    state = const SpeedTestResult(stage: SpeedTestStage.measuringPing, progress: 0.05);

    final service = ref.read(speedTestServiceProvider);
    _testSub = service.runSpeedTest().listen((result) {
      state = result;
    }, onError: (err) {
      state = state.copyWith(stage: SpeedTestStage.error);
    });
  }

  void reset() {
    _testSub?.cancel();
    state = const SpeedTestResult();
  }

  @override
  void dispose() {
    _testSub?.cancel();
    super.dispose();
  }
}

final speedTestProvider = StateNotifierProvider.autoDispose<SpeedTestNotifier, SpeedTestResult>((ref) {
  return SpeedTestNotifier(ref);
});
