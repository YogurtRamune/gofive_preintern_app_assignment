import 'package:flutter/material.dart';

/// Central theme definition for the Empeo app.
///
/// Usage:
///   theme: AppTheme.light   (in MaterialApp)
///   Theme.of(context).colorScheme.primary
///   Theme.of(context).textTheme.bodyMedium
abstract final class AppTheme {
  // ── Palette ────────────────────────────────────────────────────────────────
  static const _primary = Color(0xFFE05A2B);
  static const _onSurface = Color(0xFF1A1A1A);
  static const _surface = Color(0xFFFFFFFF);
  static const _outline = Color(0xFFE0E0E0);
  static const _hint = Color(0xFFBDBDBD);

  // ── Named background colours (set per-page on each Scaffold) ───────────────
  static const warmBackground = Color(0xFFFDF4F0);

  // ── Light theme ────────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
    fontFamily: 'Roboto',

    // Colours
    colorScheme: const ColorScheme.light(
      primary: _primary,
      onPrimary: _surface,
      surface: _surface,
      onSurface: _onSurface,
      outline: _outline,
    ),
    // Text styles
    // bodyMedium  → body copy (description paragraph)
    // bodyLarge   → text-field input value
    // labelLarge  → button labels (ElevatedButton default)
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontSize: 15.5,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: _onSurface,
      ),
      bodyLarge: TextStyle(fontSize: 15, color: _onSurface),
      labelLarge: TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _surface,
      hintStyle: const TextStyle(color: _hint, fontSize: 15),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _outline, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _primary, width: 1.6),
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: _surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
  );
}
