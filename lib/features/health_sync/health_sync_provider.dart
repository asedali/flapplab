import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/i_health_sync.dart';

/// Provider for health sync service
final healthSyncServiceProvider = Provider<IHealthSyncService>((ref) {
  return MockHealthSyncService();
});

/// Notifier for managing health app connections
class HealthSyncNotifier extends StateNotifier<HealthSyncState> {
  final IHealthSyncService _healthSyncService;

  HealthSyncNotifier(this._healthSyncService) : super(const HealthSyncState());

  /// Load all health app connections
  Future<void> loadConnections() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final connections = await _healthSyncService.getConnections();
      state = state.copyWith(
        connections: connections,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Toggle connection for a specific health app
  Future<void> toggleConnection(HealthAppType appType, bool enable) async {
    final connection = state.connections.firstWhere(
      (c) => c.type == appType,
      orElse: () => throw Exception('App not found'),
    );

    if (enable) {
      // Connect
      state = state.copyWith(isSyncing: true);
      
      await _healthSyncService.connect(appType);
      
      final updatedConnections = state.connections.map((c) {
        if (c.type == appType) {
          return c.copyWith(isEnabled: true, status: SyncStatus.connected);
        }
        return c;
      }).toList();

      state = state.copyWith(
        connections: updatedConnections,
        isSyncing: false,
      );
    } else {
      // Disconnect
      await _healthSyncService.disconnect(appType);
      
      final updatedConnections = state.connections.map((c) {
        if (c.type == appType) {
          return c.copyWith(isEnabled: false, status: SyncStatus.disconnected);
        }
        return c;
      }).toList();

      state = state.copyWith(connections: updatedConnections);
    }
  }

  /// Sync nutrition data to connected apps
  Future<bool> syncNutritionData(Map<String, dynamic> data) async {
    state = state.copyWith(isSyncing: true);
    
    try {
      final success = await _healthSyncService.syncData(data);
      state = state.copyWith(isSyncing: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// State provider for health sync
final healthSyncProvider = StateNotifierProvider<HealthSyncNotifier, HealthSyncState>((ref) {
  final healthSyncService = ref.watch(healthSyncServiceProvider);
  final notifier = HealthSyncNotifier(healthSyncService);
  notifier.loadConnections();
  return notifier;
});

/// Immutable state for health sync feature
class HealthSyncState {
  final List<HealthAppConnection> connections;
  final bool isLoading;
  final bool isSyncing;
  final String? error;

  const HealthSyncState({
    this.connections = const [],
    this.isLoading = false,
    this.isSyncing = false,
    this.error,
  });

  HealthSyncState copyWith({
    List<HealthAppConnection>? connections,
    bool? isLoading,
    bool? isSyncing,
    String? error,
  }) {
    return HealthSyncState(
      connections: connections ?? this.connections,
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      error: error ?? this.error,
    );
  }

  /// Check if any apps are connected
  bool get hasConnectedApps {
    return connections.any((c) => c.isEnabled);
  }

  /// Get count of connected apps
  int get connectedCount {
    return connections.where((c) => c.isEnabled).length;
  }
}
