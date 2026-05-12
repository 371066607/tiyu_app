import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/async_state_view.dart';
import '../home/widgets/match_card.dart';
import 'favorites_controller.dart';

class FavoritesPage extends GetView<FavoritesController> {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关注')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: AsyncStateView<List<dynamic>>(
          controller: controller,
          onRetry: controller.loadFavorites,
          emptyTitle: '还没有关注比赛',
          emptyMessage: '在首页或详情页点亮星标，比赛会出现在这里。',
          builder: (matches) {
            return RefreshIndicator(
              onRefresh: controller.loadFavorites,
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: matches.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final match = matches[index];
                  return MatchCard(
                    match: match,
                    isFavorite: true,
                    onTap: () {}, // TODO: Navigate to match detail
                    onFavoriteTap: () => controller.toggleFavorite(match),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}