import 'package:flutter/material.dart';

class NotificationPermissionDialog extends StatelessWidget {
  const NotificationPermissionDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const NotificationPermissionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('开启通知提醒'),
      content: const Text(
        '关注比赛后，App 会为您推送开赛、进球、红牌等关键事件提醒。\n\n'
        '您随时可以在"我的"页面调整通知偏好。',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('暂不开启'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('开启通知'),
        ),
      ],
    );
  }
}
