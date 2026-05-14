import 'dart:core' hide Match;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/routes/app_pages.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/async_state_view.dart';
import '../../domain/models/match.dart';
import '../favorites/favorites_controller.dart';
import 'home_controller.dart';
import 'widgets/date_selector.dart';
import 'widgets/match_card.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesController = Get.find<FavoritesController>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '实时赛事',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Obx(
                () => Text(
                  'Mock Live · 最近更新 ${Formatters.kickoffFormat.format(controller.lastUpdated.value)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: HomeCategory.values.map((category) {
                      final isSelected =
                          controller.selectedCategory.value == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(category.label),
                          selected: isSelected,
                          onSelected: (_) => controller.selectCategory(category),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => DateSelector(
                  dates: controller.availableDates,
                  selectedDate: controller.selectedDate.value,
                  onSelected: controller.selectDate,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: AsyncStateView<List<Match>>(
                  controller: controller,
                  onRetry: controller.loadFixtures,
                  emptyTitle: '这个分类还没有比赛',
                  emptyMessage: '当前只准备了足球 MVP 数据，其它项目已经预留扩展位。',
                  builder: (matches) {
                    return Obx(
                      () {
                        final ids = favoritesController.favoriteIds.toSet();
                        return RefreshIndicator(
                          onRefresh: controller.loadFixtures,
                          child: ListView.separated(
                            padding: const EdgeInsets.only(bottom: 28),
                            itemCount: matches.length,
                            separatorBuilder: (_, _) => const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final match = matches[index];
                              return MatchCard(
                                match: match,
                                isFavorite: ids.contains(match.id),
                                onTap: () => Get.toNamed(
                                  AppRoutes.matchDetail,
                                  parameters: {
                                    AppRoutes.matchIdParam: match.id,
                                  },
                                ),
                                onFavoriteTap: () =>
                                    favoritesController.toggleFavorite(match.id),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
