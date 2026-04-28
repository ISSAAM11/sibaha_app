import 'package:flutter/material.dart';

/// Single source of truth for every color used in the app.
/// Usage: AppColors.primary, AppColors.errorColor, etc.
abstract final class AppColors {
  static const primary             = Color(0xFF0058BC);
  static const primaryContainer    = Color(0xFF0070EB);
  static const onPrimary           = Color(0xFFFFFFFF);
  static const onSurface           = Color(0xFF1C1B1B);
  static const onSurfaceVariant    = Color(0xFF414755);
  static const outline             = Color(0xFF717786);
  static const outlineVariant      = Color(0xFFC1C6D7);
  static const surfaceContainerLow = Color(0xFFF6F3F2);
  static const errorColor          = Color(0xFFBA1A1A);
  static const errorContainer      = Color(0xFFFFDAD6);
  static const secondaryFixedDim   = Color(0xFF00DBE7);
}
