import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../domain/models/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class LocalSettingsRepository implements SettingsRepository {
  LocalSettingsRepository(this.storage);

  static const _settingsKey = 'app_settings';

  final GetStorage storage;

  @override
  Future<AppSettings> loadSettings() async {
    final raw = storage.read<Map<dynamic, dynamic>>(_settingsKey);
    if (raw == null) {
      return const AppSettings.defaults();
    }

    return AppSettings(
      themeMode: _themeModeFromRaw(raw['themeMode']?.toString()),
      allowNotifications: raw['allowNotifications'] == true,
      goalNotifications: raw['goalNotifications'] != false,
      redCardNotifications: raw['redCardNotifications'] != false,
      kickoffNotifications: raw['kickoffNotifications'] != false,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await storage.write(_settingsKey, <String, dynamic>{
      'themeMode': settings.themeMode.name,
      'allowNotifications': settings.allowNotifications,
      'goalNotifications': settings.goalNotifications,
      'redCardNotifications': settings.redCardNotifications,
      'kickoffNotifications': settings.kickoffNotifications,
    });
  }

  ThemeMode _themeModeFromRaw(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
