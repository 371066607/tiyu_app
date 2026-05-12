import 'package:flutter/material.dart';

class AppSettings {
  const AppSettings({
    required this.themeMode,
    required this.allowNotifications,
    required this.goalNotifications,
    required this.redCardNotifications,
    required this.kickoffNotifications,
  });

  const AppSettings.defaults()
    : this(
        themeMode: ThemeMode.system,
        allowNotifications: false,
        goalNotifications: true,
        redCardNotifications: true,
        kickoffNotifications: true,
      );

  final ThemeMode themeMode;
  final bool allowNotifications;
  final bool goalNotifications;
  final bool redCardNotifications;
  final bool kickoffNotifications;

  AppSettings copyWith({
    ThemeMode? themeMode,
    bool? allowNotifications,
    bool? goalNotifications,
    bool? redCardNotifications,
    bool? kickoffNotifications,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      allowNotifications: allowNotifications ?? this.allowNotifications,
      goalNotifications: goalNotifications ?? this.goalNotifications,
      redCardNotifications: redCardNotifications ?? this.redCardNotifications,
      kickoffNotifications:
          kickoffNotifications ?? this.kickoffNotifications,
    );
  }
}
