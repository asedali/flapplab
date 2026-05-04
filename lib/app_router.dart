import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/chat_home/chat_home_screen.dart';
import '../features/scan/scan_progress_screen.dart';
import '../features/result/result_screen.dart';
import '../features/health_sync/health_sync_screen.dart';

/// App router configuration using go_router
/// 
/// Routes:
/// - / : Chat home screen (AI-first interface)
/// - /scan : Scan progress screen with animations
/// - /result : Result display (shown in chat, but available for direct nav)
/// - /health-sync : Health app integration screen

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Home - AI Chat First
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const ChatHomeScreen(),
    ),

    // Scan Progress
    GoRoute(
      path: '/scan',
      name: 'scan',
      builder: (context, state) => const ScanProgressScreen(),
    ),

    // Result (standalone view)
    GoRoute(
      path: '/result',
      name: 'result',
      builder: (context, state) => const ResultScreen(),
    ),

    // Health Sync
    GoRoute(
      path: '/health-sync',
      name: 'health-sync',
      builder: (context, state) => const HealthSyncScreen(),
    ),
  ],

  // Error handling for undefined routes
  errorBuilder: (context, state) => Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Text(
        'Page not found',
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
    ),
  ),
);
