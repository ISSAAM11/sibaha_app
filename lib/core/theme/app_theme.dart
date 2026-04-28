import 'package:flutter/material.dart';
import 'package:sibaha_app/core/theme/app_border_radius.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';

abstract final class AppTheme {
  static const _fontFamily = 'Lexend';

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        fontFamily: _fontFamily,
        primaryColorLight: Colors.grey.shade200,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onError: AppColors.onSurface,
        ),
        hoverColor: Colors.grey[200],
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 48,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.02 * 48,
          ),
          headlineLarge: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.01 * 32,
          ),
          headlineMedium: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 14,
            letterSpacing: 0.05 * 14,
            fontWeight: FontWeight.w600,
          ),
          labelMedium: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          labelSmall: TextStyle(
            fontFamily: _fontFamily,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        dialogTheme: const DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.zeroRadius,
          ),
        ),
      );
}
