import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
  // Warm sunny palette for vibrant light mode
  seedColor: const Color(0xFFFFA726), // Amber Orange
    brightness: Brightness.light,
  );
  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF6366F1),
    brightness: Brightness.dark,
  );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: _lightScheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Warm, subtle background that matches sunny gradients
        scaffoldBackgroundColor: const Color(0xFFFEF9F1),
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
        ),
        dividerColor: const Color(0x1F000000),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: _darkScheme,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        cardTheme: const CardThemeData(
          elevation: 0,
          // Color and shape handled in custom glassCard
        ),
      );
}
