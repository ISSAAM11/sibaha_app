import 'package:flutter/material.dart';
import 'package:sibaha_app/core/theme/app_colors.dart';

/// Reusable text style presets that map to the Lexend design system.
/// Usage: AppTextStyles.screenTitle, AppTextStyles.fieldLabel, etc.
abstract final class AppTextStyles {
  /// 32px / w600 — page headlines (Verify Identity, Email Recovery, etc.)
  static const screenTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurface,
    letterSpacing: -0.32,
  );

  /// 16px / w400 — descriptive paragraphs beneath headlines
  static const subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.onSurfaceVariant,
    height: 1.5,
  );

  /// 14px / w600 — input field labels (grey)
  static const fieldLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onSurfaceVariant,
    letterSpacing: 0.7,
  );

  /// 14px / w600 — input field labels (primary blue)
  static const fieldLabelPrimary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    letterSpacing: 0.7,
  );

  /// 16px / w400 — text typed inside input fields
  static const fieldInput = TextStyle(
    fontSize: 16,
    color: AppColors.onSurface,
  );

  /// 14px / w600 — button labels
  static const buttonLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.7,
  );

  /// 12px / w500 — small links (Forgot?, Resend Code)
  static const linkPrimary = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  /// 16px / w600 — inline action links (Create Account)
  static const bodyLink = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  /// 12px / w500 — small captions (Didn't receive the code?)
  static const caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.onSurfaceVariant,
  );

  /// 14px / w400 — inline error messages
  static const errorText = TextStyle(
    fontSize: 14,
    color: AppColors.errorColor,
  );
}
