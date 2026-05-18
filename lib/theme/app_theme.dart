import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundDark = Color(0xFF0A0A0F);
  static const Color surfaceColor = Color(0xFF1A1A24);
  static const Color cardColor = Color(0xFF252530);
  static const Color primaryColor = Color(0xFF4C9AFF);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C0);
  static const Color textHint = Color(0xFF6B6B7A);
  static const Color errorColor = Color(0xFFFF6B6B);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      error: errorColor,
      surface: surfaceColor,
      background: backgroundDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      elevation: 0,
      titleTextStyle: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
      iconTheme: IconThemeData(color: textPrimary),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textSecondary, fontSize: 14),
      titleLarge: TextStyle(color: textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryColor, width: 1.5)),
      labelStyle: TextStyle(color: textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    ),
    cardTheme: const CardThemeData(color: cardColor, elevation: 2),
  );
}