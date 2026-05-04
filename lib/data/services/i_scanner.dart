import 'package:flutter/foundation.dart';
import '../models/material_result.dart';

/// Scan status enum
enum ScanStatus {
  idle,
  calibrating,
  analyzing,
  complete,
  error,
}

/// Abstract interface for scanner service
/// 
/// NOTE: In production, this will be replaced with actual hardware/AI integration
/// Current implementation is a demo mock that simulates scanning behavior
abstract class IScannerService {
  /// Start scanning process
  /// Returns a stream of progress values (0.0 to 1.0)
  Stream<double> startScan();

  /// Get the current scan status
  ScanStatus get currentStatus;

  /// Perform a full scan and return result
  /// This is a convenience method that combines startScan and waits for completion
  Future<MaterialResult> scanAndAnalyze(String? materialHint);

  /// Cancel ongoing scan
  void cancelScan();

  /// Dispose resources
  void dispose();
}

/// Demo implementation of scanner service
/// Simulates realistic scanning behavior with delays and progress
class DemoScannerService implements IScannerService {
  ScanStatus _currentStatus = ScanStatus.idle;
  bool _isScanning = false;

  @override
  ScanStatus get currentStatus => _currentStatus;

  @override
  Stream<double> startScan() {
    if (_isScanning) {
      throw StateError('Scan already in progress');
    }

    _isScanning = true;
    
    return Stream<double>.periodic(
      const Duration(milliseconds: 100),
      (count) {
        final progress = count / 30.0; // 3 seconds total
        
        if (progress < 0.33) {
          _currentStatus = ScanStatus.calibrating;
        } else if (progress < 0.85) {
          _currentStatus = ScanStatus.analyzing;
        } else {
          _currentStatus = ScanStatus.complete;
        }

        if (progress >= 1.0) {
          _isScanning = false;
          return 1.0;
        }

        // Add slight jitter for realism
        final jitter = (count % 3 == 0) ? 0.01 : 0.0;
        return (progress + jitter).clamp(0.0, 1.0);
      },
    ).takeWhile((_) => _isScanning);
  }

  @override
  Future<MaterialResult> scanAndAnalyze(String? materialHint) async {
    _currentStatus = ScanStatus.calibrating;
    
    // Simulate 3-second scan
    await Future.delayed(const Duration(seconds: 3));
    
    _currentStatus = ScanStatus.complete;
    
    // Use hint or default to demo config material
    final materialKey = materialHint ?? 'apple';
    final result = MaterialResult.fromDemoData(materialKey);
    
    _isScanning = false;
    _currentStatus = ScanStatus.idle;
    
    return result;
  }

  @override
  void cancelScan() {
    _isScanning = false;
    _currentStatus = ScanStatus.idle;
  }

  @override
  void dispose() {
    cancelScan();
  }
}

// TODO: Replace DemoScannerService with actual hardware integration
// Production implementation should:
// 1. Connect to spectral sensor hardware via platform channels
// 2. Capture raw spectral data
// 3. Send to AI backend for analysis
// 4. Return MaterialResult with real confidence scores
