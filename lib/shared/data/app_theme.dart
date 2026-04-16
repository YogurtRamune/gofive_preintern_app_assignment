import 'package:flutter/material.dart';

/// Central theme definition for the Empeo app.
///
/// Usage:
///   theme: AppTheme.light   (in MaterialApp)
///   Theme.of(context).colorScheme.primary
///   Theme.of(context).textTheme.bodyMedium
abstract final class AppTheme {
  // ── Palette ──────────────────────────────────────────────────────────────
  static const primary = Color(0xFFE05A2B);
  static const onSurface = Color(0xFF1A1A1A);
  static const surface = Color(0xFFFFFFFF);
  static const outline = Color(0xFFE0E0E0);
  static const hint = Color(0xFFBDBDBD);

  // ── Font ─────────────────────────────────────────────────────────────────
  static const font = 'VarelaRound'; // matches the family name in pubspec.yaml

  // ── Named background colours (set per-page on each Scaffold) ─────────────
  static const warmBackground = Color(0xFFFDF4F0);

  // ── Light theme ──────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
    fontFamily: font, // ← global fallback for the whole app
    // Colours
    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: surface,
      surface: surface,
      onSurface: onSurface,
      outline: outline,
    ),

    // Text styles
    // bodyMedium  → body copy (description paragraph)
    // bodyLarge   → text-field input value
    // labelLarge  → button labels (ElevatedButton default)
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontFamily: font,
        fontSize: 15.5,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      bodyLarge: TextStyle(
        fontFamily: font,
        fontSize: 15,
        color: onSurface
      ),
      labelLarge: TextStyle(
        fontFamily: font,
        fontSize: 16.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      hintStyle: const TextStyle(fontFamily: font, color: hint, fontSize: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: outline, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary, width: 1.6),
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: surface,
        elevation: 0,
        textStyle: const TextStyle(fontFamily: font), // ← button label
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontFamily: font), // ← button label
      ),
    ),
  );
}
