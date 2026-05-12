import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AsyncStateView<T> extends StatelessWidget {
  const AsyncStateView({
    required this.controller,
    required this.builder,
    super.key,
    this.onRetry,
    this.emptyTitle = '暂无内容',
    this.emptyMessage = '等会儿再来看看吧',
  });

  final StateMixin<T> controller;
  final Widget Function(T state) builder;
  final VoidCallback? onRetry;
  final String emptyTitle;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      builder,
      onLoading: const Center(child: CircularProgressIndicator()),
      onEmpty: _StateMessage(
        title: emptyTitle,
        message: emptyMessage,
        actionLabel: onRetry == null ? null : '重新加载',
        onTap: onRetry,
      ),
      onError: (error) => _StateMessage(
        title: '加载失败',
        message: error ?? '请稍后重试',
        actionLabel: onRetry == null ? null : '重试',
        onTap: onRetry,
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onTap,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.sports_soccer_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(title, style: textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              message,
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onTap != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onTap, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
