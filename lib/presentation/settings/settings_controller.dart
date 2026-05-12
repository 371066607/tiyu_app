import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/models/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsController extends GetxController {
  SettingsController(this.settingsRepository);

  final SettingsRepository settingsRepository;
  final settings = const AppSettings.defaults().obs;

  ThemeMode get themeMode => settings.value.themeMode;

  Future<void> loadSettings() async {
    settings.value = await settingsRepository.loadSettings();
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    settings.value = settings.value.copyWith(themeMode: themeMode);
    await settingsRepository.saveSettings(settings.value);
  }

  Future<void> toggleNotifications(bool value) async {
    settings.value = settings.value.copyWith(allowNotifications: value);
    await settingsRepository.saveSettings(settings.value);
  }

  Future<void> toggleGoalNotifications(bool value) async {
    settings.value = settings.value.copyWith(goalNotifications: value);
    await settingsRepository.saveSettings(settings.value);
  }

  Future<void> toggleRedCardNotifications(bool value) async {
    settings.value = settings.value.copyWith(redCardNotifications: value);
    await settingsRepository.saveSettings(settings.value);
  }

  Future<void> toggleKickoffNotifications(bool value) async {
    settings.value = settings.value.copyWith(kickoffNotifications: value);
    await settingsRepository.saveSettings(settings.value);
  }
}
