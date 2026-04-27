import 'package:flutter/material.dart';

abstract final class AppBorderRadius {
  // Extra small border radius
  static const xs = 4.0;

  // Small border radius
  static const sm = 8.0;

  // Medium border radius
  static const md = 12.0;

  // Large border radius
  static const lg = 16.0;

  // Extra large border radius
  static const xl = 24.0;

  // Pill-shaped border radius
  static const pill = 50.0;

  // BorderRadius objects for convenience
  static const BorderRadius zeroRadius = BorderRadius.zero;
  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(pill));
}
