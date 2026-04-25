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
  static const icon = Color.fromARGB(255, 181, 143, 143);
  static const pinBackground = Color.fromARGB(255, 251, 254, 255);

  // ── Font ─────────────────────────────────────────────────────────────────
  static const font = 'VarelaRound'; // matches the family name in pubspec.yaml

  // ── Named background colours (set per-page on each Scaffold) ─────────────
  static const warmBackground = Color(0xFFFFFFFF); //Color(0xFFFDF4F0);

  // ── Light theme ──────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
    fontFamily: font,
    extensions: const [AppTextStyles.light],
    badgeTheme: BadgeThemeData(
      backgroundColor: Color.fromARGB(255, 255, 42, 56),
    ),
    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: surface,
      surface: surface,
      onSurface: onSurface,
      outline: outline,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        fontFamily: font,
        fontSize: 13,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      bodyLarge: TextStyle(fontFamily: font, fontSize: 13.5, color: onSurface),
      labelLarge: TextStyle(
        fontFamily: font,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      hintStyle: const TextStyle(fontFamily: font, color: hint, fontSize: 13.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: outline, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primary, width: 1.6),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: surface,
        elevation: 0,
        shadowColor: Colors.transparent,
        textStyle: const TextStyle(
          fontFamily: font,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontFamily: font,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Color.alphaBlend(
        Colors.white.withAlpha(200),
        HSVColor.fromColor(primary).withSaturation(1).withValue(1).toColor(),
      ),
      strokeWidth: 4,
    ),
  );
}

/// Custom text styles that don't belong in Flutter's standard [TextTheme].
///
/// Access via:
///   `Theme.of(context).extension<AppTextStyles>()!.sectionHeader`
///   `Theme.of(context).extension<AppTextStyles>()!.avatarInitial`
class AppTextStyles extends ThemeExtension<AppTextStyles> {
  const AppTextStyles({
    required this.sectionHeader,
    required this.avatarInitial,
    required this.pinText,
    required this.pinHeader,
    required this.pinBody,
  });

  /// Bold label used for list section headers (e.g. "Own Team").
  final TextStyle sectionHeader;

  /// Base style for initials inside a [CircleAvatar] — white + semi-bold.
  /// Supply [fontSize] via [copyWith] to match the avatar radius:
  ///   `ext.avatarInitial.copyWith(fontSize: 14)`
  final TextStyle avatarInitial;

  final TextStyle pinText;

  final TextStyle pinHeader;

  final TextStyle pinBody;

  /// Default instance registered in [AppTheme.light].
  static const light = AppTextStyles(
    sectionHeader: TextStyle(
      fontFamily: AppTheme.font,
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: AppTheme.onSurface,
    ),
    avatarInitial: TextStyle(
      fontFamily: AppTheme.font,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    ),
    pinText: TextStyle(
      fontFamily: AppTheme.font,
      fontSize: 19,
      fontWeight: FontWeight.w700,
      color: AppTheme.onSurface,
    ),
    pinHeader: TextStyle(
      fontFamily: AppTheme.font,
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: AppTheme.onSurface,
    ),
    pinBody: TextStyle(
      fontFamily: AppTheme.font,
      fontSize: 13,
      height: 1.55,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.2,
      color: AppTheme.onSurface,
    ),
  );

  @override
  AppTextStyles copyWith({
    TextStyle? sectionHeader,
    TextStyle? avatarInitial,
    TextStyle? pinText,
    TextStyle? pinHeader,
    TextStyle? pinBody,
  }) => AppTextStyles(
    sectionHeader: sectionHeader ?? this.sectionHeader,
    avatarInitial: avatarInitial ?? this.avatarInitial,
    pinText: pinText ?? this.pinText,
    pinHeader: pinHeader ?? this.pinHeader,
    pinBody: pinBody ?? this.pinBody,
  );

  @override
  AppTextStyles lerp(AppTextStyles? other, double t) {
    if (other == null) return this;
    return AppTextStyles(
      sectionHeader: TextStyle.lerp(sectionHeader, other.sectionHeader, t)!,
      avatarInitial: TextStyle.lerp(avatarInitial, other.avatarInitial, t)!,
      pinText: TextStyle.lerp(pinText, other.pinText, t)!,
      pinHeader: TextStyle.lerp(pinHeader, other.pinHeader, t)!,
      pinBody: TextStyle.lerp(pinBody, other.pinBody, t)!,
    );
  }
}
