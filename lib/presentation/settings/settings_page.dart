import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_pages.dart';
import 'settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的')),
      body: Obx(
        () {
          final settings = controller.settings.value;
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '主题模式',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        children: [
                          _ThemeChip(
                            label: '跟随系统',
                            selected: settings.themeMode == ThemeMode.system,
                            onTap: () =>
                                controller.updateThemeMode(ThemeMode.system),
                          ),
                          _ThemeChip(
                            label: '浅色',
                            selected: settings.themeMode == ThemeMode.light,
                            onTap: () =>
                                controller.updateThemeMode(ThemeMode.light),
                          ),
                          _ThemeChip(
                            label: '深色',
                            selected: settings.themeMode == ThemeMode.dark,
                            onTap: () =>
                                controller.updateThemeMode(ThemeMode.dark),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      value: settings.allowNotifications,
                      onChanged: controller.toggleNotifications,
                      title: const Text('开启通知提醒'),
                      subtitle: const Text('为关注比赛预留开赛、进球、红牌提醒能力'),
                    ),
                    SwitchListTile(
                      value: settings.goalNotifications,
                      onChanged: settings.allowNotifications
                          ? controller.toggleGoalNotifications
                          : null,
                      title: const Text('进球提醒'),
                    ),
                    SwitchListTile(
                      value: settings.redCardNotifications,
                      onChanged: settings.allowNotifications
                          ? controller.toggleRedCardNotifications
                          : null,
                      title: const Text('红牌提醒'),
                    ),
                    SwitchListTile(
                      value: settings.kickoffNotifications,
                      onChanged: settings.allowNotifications
                          ? controller.toggleKickoffNotifications
                          : null,
                      title: const Text('开赛提醒'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.privacy_tip_outlined),
                      title: const Text('隐私与权限说明'),
                      subtitle: const Text('说明通知与本地偏好存储用途'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Get.toNamed(AppRoutes.privacy),
                    ),
                    const Divider(height: 1),
                    const ListTile(
                      leading: Icon(Icons.info_outline_rounded),
                      title: Text('版本信息'),
                      subtitle: Text('MVP Mock Build · 0.1.0'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
