import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/haptics.dart';
import '../../../data/services/i_health_sync.dart';
import '../health_sync_provider.dart';

/// Health app integration screen with toggle switches
class HealthSyncScreen extends ConsumerStatefulWidget {
  const HealthSyncScreen({super.key});

  @override
  ConsumerState<HealthSyncScreen> createState() => _HealthSyncScreenState();
}

class _HealthSyncScreenState extends ConsumerState<HealthSyncScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(healthSyncProvider);
    final notifier = ref.read(healthSyncProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Health Apps'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Connect Health Apps',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sync your nutrition data with your favorite health platforms',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms)
                .slideX(begin: -0.1, end: 0),

            // Connection status banner
            if (state.hasConnectedApps)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.successColor.withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppTheme.successColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${state.connectedCount} app${state.connectedCount > 1 ? 's' : ''} connected',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.successColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 100.ms)
                  .scale(delay: 100.ms, duration: 300.ms),

            const SizedBox(height: 16),

            // Health apps list
            Expanded(
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.connections.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final connection = state.connections[index];
                        return _HealthAppTile(
                          connection: connection,
                          isSyncing: state.isSyncing,
                          onToggle: (enabled) {
                            AppHaptics.light();
                            notifier.toggleConnection(connection.type, enabled);
                          },
                        );
                      },
                    ),
            ),

            // Sync button (if apps are connected)
            if (state.hasConnectedApps && !state.isSyncing)
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      AppHaptics.medium();
                      final success = await notifier.syncNutritionData({
                        'calories': 95,
                        'protein': 0.5,
                        'carbs': 25.0,
                        'fat': 0.3,
                      });

                      if (success && mounted) {
                        _showSuccessToast();
                      }
                    },
                    icon: const Icon(Icons.sync),
                    label: const Text('Sync Now'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),
            ],

            // Loading indicator
            if (state.isSyncing)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Syncing to ${state.connectedCount} app${state.connectedCount > 1 ? 's' : ''}...',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSuccessToast() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppTheme.successColor, size: 20),
            const SizedBox(width: 12),
            const Text(
              'Data synced successfully!',
              style: TextStyle(fontFamily: 'Inter', fontSize: 14),
            ),
          ],
        ),
        backgroundColor: AppTheme.surfaceDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _HealthAppTile extends StatelessWidget {
  final HealthAppConnection connection;
  final bool isSyncing;
  final ValueChanged<bool> onToggle;

  const _HealthAppTile({
    required this.connection,
    this.isSyncing = false,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: connection.isEnabled
              ? AppTheme.primaryColor.withOpacity(0.3)
              : AppTheme.surfaceLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // App icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getAppColor(connection.type).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getAppIcon(connection.type),
              color: _getAppColor(connection.type),
              size: 24,
            ),
          ),

          const SizedBox(width: 14),

          // App info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  connection.displayName,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStatusText(connection),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: connection.isEnabled
                        ? AppTheme.successColor
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Toggle switch
          Transform.scale(
            scale: 0.9,
            child: CupertinoSwitch(
              value: connection.isEnabled,
              onChanged: isSyncing ? null : onToggle,
              activeColor: AppTheme.primaryColor,
              trackColor: AppTheme.surfaceLight,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAppIcon(HealthAppType type) {
    switch (type) {
      case HealthAppType.appleHealth:
        return Icons.favorite;
      case HealthAppType.googleFit:
        return Icons.fitness_center;
      case HealthAppType.myFitnessPal:
        return Icons.restaurant;
    }
  }

  Color _getAppColor(HealthAppType type) {
    switch (type) {
      case HealthAppType.appleHealth:
        return const Color(0xFFFF2D55);
      case HealthAppType.googleFit:
        return const Color(0xFF34C759);
      case HealthAppType.myFitnessPal:
        return const Color(0xFF0A84FF);
    }
  }

  String _getStatusText(HealthAppConnection connection) {
    if (connection.isEnabled) {
      if (connection.lastSyncedAt != null) {
        return 'Last synced ${_formatTimeAgo(connection.lastSyncedAt!)}';
      }
      return 'Connected';
    }
    return 'Not connected';
  }

  String _formatTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
