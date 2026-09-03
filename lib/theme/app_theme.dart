import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color ink = Color(0xFF172020);
  static const Color mutedInk = Color(0xFF53605D);
  static const Color canvas = Color(0xFFF4F1EA);
  static const Color paper = Color(0xFFFFFDF8);
  static const Color signal = Color(0xFFFF5A36);
  static const Color line = Color(0xFFD8D3C8);

  static ThemeData get light {
    final ColorScheme colorScheme =
        ColorScheme.fromSeed(
          seedColor: signal,
          brightness: Brightness.light,
          surface: paper,
        ).copyWith(
          primary: ink,
          onPrimary: Colors.white,
          secondary: signal,
          onSecondary: Colors.white,
          surface: paper,
          onSurface: ink,
          outline: line,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: canvas,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: ink,
          fontSize: 64,
          fontWeight: FontWeight.w800,
          height: 0.98,
          letterSpacing: -1.8,
        ),
        headlineSmall: TextStyle(
          color: ink,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          height: 1.1,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: ink,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.15,
          letterSpacing: -0.2,
        ),
        bodyLarge: TextStyle(
          color: mutedInk,
          fontSize: 17,
          fontWeight: FontWeight.w400,
          height: 1.55,
        ),
        bodyMedium: TextStyle(
          color: mutedInk,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        labelLarge: TextStyle(
          color: ink,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: paper,
        selectedColor: ink,
        side: const BorderSide(color: line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(color: ink, fontWeight: FontWeight.w600),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ink,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
