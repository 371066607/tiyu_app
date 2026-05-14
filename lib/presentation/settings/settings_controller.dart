import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_pages.dart';
import '../../domain/models/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/services/notification_service.dart';
import 'widgets/permission_dialog.dart';

class SettingsController extends GetxController {
  SettingsController(this.settingsRepository);

  final SettingsRepository settingsRepository;
  final settings = const AppSettings.defaults().obs;

  ThemeMode get themeMode => settings.value.themeMode;
  final appVersion = '1.0.0+1'.obs;

  late final NotificationService _notificationService;

  @override
  void onInit() {
    super.onInit();
    _notificationService = Get.find<NotificationService>();
  }

  Future<void> loadSettings() async {
    settings.value = await settingsRepository.loadSettings();
    Get.changeThemeMode(settings.value.themeMode);
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    settings.value = settings.value.copyWith(themeMode: themeMode);
    await settingsRepository.saveSettings(settings.value);
    Get.changeThemeMode(themeMode);
  }

  Future<void> toggleNotifications(bool value) async {
    if (value) {
      final permission = await _notificationService.permission;
      if (permission == NotificationPermission.notDetermined) {
        final granted = await NotificationPermissionDialog.show(Get.context!);
        if (granted != true) {
          Get.snackbar('通知未开启', '你可以稍后在“我的”页面重新打开通知');
          return;
        }
        final result = await _notificationService.requestPermission();
        if (!result) {
          Get.snackbar('通知权限被拒绝', '系统未授予通知权限，测试提醒不会生效');
          return;
        }
      }
    }

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

  void openPrivacyPage() {
    Get.toNamed(AppRoutes.privacy);
  }

  Future<void> sendTestNotification() async {
    final granted = await _notificationService.requestPermission();
    if (!granted) {
      Get.snackbar('发送失败', '请先在系统设置中允许通知权限');
      return;
    }

    await _notificationService.showMatchNotification(
      matchId: 'test',
      title: '🔔 测试通知',
      body: '如果您看到这条通知，说明本地通知已正常工作。',
    );
    Get.snackbar('测试通知已发送', '请留意系统通知栏中的提醒');
  }
}
