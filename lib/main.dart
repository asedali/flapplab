import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme/app_theme.dart';
import 'app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Initialize Isar database for production
  // final isar = await Isar.open([MaterialResultSchema, ChatMessageSchema]);

  runApp(
    const ProviderScope(
      child: NooraSenseApp(),
    ),
  );
}

class NooraSenseApp extends StatelessWidget {
  const NooraSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NooraSense',
      debugShowCheckedModeBanner: false,
      
      // Theme configuration - Premium dark theme
      theme: AppTheme.darkTheme.copyWith(
        textTheme: AppTheme.interTextTheme,
      ),
      darkTheme: AppTheme.darkTheme.copyWith(
        textTheme: AppTheme.interTextTheme,
      ),
      themeMode: ThemeMode.dark, // Force dark mode for premium look
      
      // Router configuration
      routerConfig: appRouter,
      
      // Google Fonts license
      builder: (context, child) {
        return GoogleFonts.overrideGoogleFonts(
          context: context,
          child: child!,
        );
      },
    );
  }
}
