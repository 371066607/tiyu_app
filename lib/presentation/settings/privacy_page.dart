import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('隐私说明')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _InfoCard(
            title: '通知权限',
            message: '仅在你主动开启提醒后，App 才会为关注比赛发送开赛、进球、红牌等通知。',
          ),
          SizedBox(height: 14),
          _InfoCard(
            title: '本地轻存储',
            message: '当前使用 GetStorage 保存主题偏好和关注列表，数据默认只保存在本机。',
          ),
          SizedBox(height: 14),
          _InfoCard(
            title: 'MVP 阶段说明',
            message: '当前版本以 Mock 数据演示 MVP 主链路，后续再对接真实接口和实时通道。',
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
