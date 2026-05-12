import 'package:flutter/material.dart';
import 'feature_flags.dart';

class AppTheme {
  static ThemeData get currentTheme {
    return FeatureFlags.enableDarkMode ? ThemeData.dark() : ThemeData.light();
  }
}