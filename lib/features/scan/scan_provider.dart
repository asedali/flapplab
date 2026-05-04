import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/i_scanner.dart';

/// Provider for the scanner service
final scannerServiceProvider = Provider<IScannerService>((ref) {
  return DemoScannerService();
});

/// Notifier for managing scan state and progress
class ScanNotifier extends StateNotifier<ScanState> {
  final IScannerService _scannerService;

  ScanNotifier(this._scannerService) : super(const ScanState());

  /// Start a new scan
  Future<void> startScan() async {
    if (state.isScanning) return;

    state = state.copyWith(
      isScanning: true,
      progress: 0.0,
      status: ScanStatus.calibrating,
      error: null,
    );

    try {
      // Listen to progress updates
      await for (final progress in _scannerService.startScan()) {
        if (!state.isScanning) break;

        final status = progress < 0.33
            ? ScanStatus.calibrating
            : progress < 0.85
                ? ScanStatus.analyzing
                : ScanStatus.complete;

        state = state.copyWith(
          progress: progress,
          status: status,
        );

        if (progress >= 1.0) {
          break;
        }
      }

      // Get the result after scan completes
      final result = await _scannerService.scanAndAnalyze(null);
      state = state.copyWith(
        isScanning: false,
        progress: 1.0,
        status: ScanStatus.complete,
        result: result,
      );
    } catch (e) {
      state = state.copyWith(
        isScanning: false,
        status: ScanStatus.error,
        error: e.toString(),
      );
    }
  }

  /// Cancel ongoing scan
  void cancelScan() {
    _scannerService.cancelScan();
    state = const ScanState();
  }

  /// Reset state for new scan
  void reset() {
    state = const ScanState();
  }
}

/// State provider for scan management
final scanProvider = StateNotifierProvider<ScanNotifier, ScanState>((ref) {
  final scannerService = ref.watch(scannerServiceProvider);
  return ScanNotifier(scannerService);
});

/// Immutable state for scan feature
class ScanState {
  final bool isScanning;
  final double progress;
  final ScanStatus status;
  final String? error;
  final dynamic result;

  const ScanState({
    this.isScanning = false,
    this.progress = 0.0,
    this.status = ScanStatus.idle,
    this.error,
    this.result,
  });

  ScanState copyWith({
    bool? isScanning,
    double? progress,
    ScanStatus? status,
    String? error,
    dynamic result,
  }) {
    return ScanState(
      isScanning: isScanning ?? this.isScanning,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      error: error ?? this.error,
      result: result ?? this.result,
    );
  }

  /// Get status text for UI display
  String get statusText {
    switch (status) {
      case ScanStatus.calibrating:
        return 'Calibrating sensors...';
      case ScanStatus.analyzing:
        return 'Analyzing material...';
      case ScanStatus.complete:
        return 'Analysis complete';
      case ScanStatus.error:
        return 'Scan failed';
      case ScanStatus.idle:
        return 'Ready to scan';
    }
  }

  /// Get loading phase for animations
  String get loadingPhase {
    if (progress < 0.33) return 'calibrating';
    if (progress < 0.85) return 'analyzing';
    return 'complete';
  }
}
