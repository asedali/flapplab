import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';
import '../scan_provider.dart';

/// Premium scan progress screen with smooth animations
/// Shows calibration → analyzing → complete flow
class ScanProgressScreen extends ConsumerStatefulWidget {
  const ScanProgressScreen({super.key});

  @override
  ConsumerState<ScanProgressScreen> createState() => _ScanProgressScreenState();
}

class _ScanProgressScreenState extends ConsumerState<ScanProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _progressAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    // Start scan when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      ref.read(scanProvider.notifier).startScan();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanProvider);

    // Auto-navigate to result when complete
    if (scanState.status == ScanStatus.complete && scanState.result != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppHaptics.success();
        context.go('/result');
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated scan visualization
              _buildScanVisualization(scanState.progress),
              
              const SizedBox(height: 48),

              // Progress text with phase indicator
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  scanState.statusText,
                  key: ValueKey(scanState.loadingPhase),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .shimmer(duration: 1500.ms, color: AppTheme.primaryColor.withOpacity(0.3)),

              const SizedBox(height: 16),

              // Percentage text
              Text(
                '${(scanState.progress * 100).toInt()}%',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .scale(delay: 0.ms, duration: 800.ms, begin: const Offset(0.95, 0.95))
                  .then()
                  .scale(duration: 800.ms, begin: const Offset(1.05, 1.05)),

              const SizedBox(height: 64),

              // Cancel button (only during scanning)
              if (scanState.isScanning)
                TextButton.icon(
                  onPressed: () {
                    AppHaptics.medium();
                    ref.read(scanProvider.notifier).cancelScan();
                    context.pop();
                  },
                  icon: const Icon(Icons.close, size: 20),
                  label: const Text('Cancel Scan'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.textSecondary,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms)
                    .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanVisualization(double progress) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
                width: 2,
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(delay: 0.ms, duration: 1000.ms)
              .then()
              .scale(duration: 1000.ms, reverse: true),

          // Middle ring with rotation
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.4),
                width: 2,
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .rotate(delay: 0.ms, duration: 2000.ms, begin: 0, end: 2 * 3.14159),

          // Inner pulse circle
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryColor.withOpacity(0.6),
                  AppTheme.primaryColor.withOpacity(0.2),
                  Colors.transparent,
                ],
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat())
              .scale(delay: 0.ms, duration: 800.ms, begin: const Offset(0.8, 0.8))
              .then()
              .scale(duration: 800.ms, begin: const Offset(1.2, 1.2), reverse: true),

          // Center icon
          Icon(
            _getIconForPhase(progress),
            size: 48,
            color: AppTheme.primaryColor,
          )
              .animate()
              .fadeIn(delay: 200.ms)
              .scale(delay: 200.ms, duration: 300.ms, curve: Curves.elasticOut),
        ],
      ),
    );
  }

  IconData _getIconForPhase(double progress) {
    if (progress < 0.33) {
      return Icons.tune; // Calibrating
    } else if (progress < 0.85) {
      return Icons.analytics; // Analyzing
    } else {
      return Icons.check_circle_outline; // Complete
    }
  }
}
