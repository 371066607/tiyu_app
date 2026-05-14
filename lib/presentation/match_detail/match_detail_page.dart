import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/widgets/async_state_view.dart';
import '../../core/widgets/status_badge.dart';
import '../../domain/models/match_detail.dart';
import '../../domain/models/match_event.dart';
import '../../domain/models/match_statistics.dart';
import '../../domain/models/match_status.dart';
import '../favorites/favorites_controller.dart';
import 'match_detail_controller.dart';

class MatchDetailPage extends StatelessWidget {
  const MatchDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final matchId = Get.parameters['matchId'];
    if (matchId == null || matchId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('缺少比赛 ID')),
      );
    }

    final controller = Get.find<MatchDetailController>(tag: matchId);
    return Scaffold(
      appBar: AppBar(title: const Text('比赛详情')),
      body: AsyncStateView<MatchDetail>(
        controller: controller,
        onRetry: controller.loadDetail,
        emptyTitle: '暂无比赛详情',
        emptyMessage: '当前比赛详情暂不可用。',
        builder: (detail) => _DetailContent(detail: detail),
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.detail});

  final MatchDetail detail;

  @override
  Widget build(BuildContext context) {
    final favoritesController = Get.find<FavoritesController>();
    final match = detail.match;
    final textTheme = Theme.of(context).textTheme;
    final homeScore = match.score.home?.toString() ?? '-';
    final awayScore = match.score.away?.toString() ?? '-';

    return DefaultTabController(
      length: 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Column(
                children: [
                  Text(
                    '${match.league.name} · ${match.round}',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => FilledButton.tonalIcon(
                      onPressed: () =>
                          favoritesController.toggleFavorite(match.id),
                      icon: Icon(
                        favoritesController.isFavorite(match.id)
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                      ),
                      label: Text(
                        favoritesController.isFavorite(match.id)
                            ? '已关注'
                            : '关注比赛',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _TeamInfo(
                          name: match.homeTeam.shortName,
                          logoText: match.homeTeam.logoText,
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '$homeScore  -  $awayScore',
                            style: textTheme.headlineLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          StatusBadge(
                            status: match.status,
                            elapsed: match.elapsed,
                          ),
                          if (match.status == MatchStatus.scheduled)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                '${match.kickoffAt.hour.toString().padLeft(2, '0')}:${match.kickoffAt.minute.toString().padLeft(2, '0')}',
                                style: textTheme.bodySmall,
                              ),
                            ),
                        ],
                      ),
                      Expanded(
                        child: _TeamInfo(
                          name: match.awayTeam.shortName,
                          logoText: match.awayTeam.logoText,
                          isAway: true,
                        ),
                      ),
                    ],
                  ),
                  if (detail.headline.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        detail.headline,
                        style: textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                tabs: const [
                  Tab(text: '事件'),
                  Tab(text: '数据'),
                  Tab(text: '阵容'),
                ],
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).textTheme.bodyMedium?.color,
                indicatorColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
        body: TabBarView(
          children: [
            _EventsTab(events: detail.events),
            _StatisticsTab(statistics: detail.statistics),
            const Center(child: Text('阵容功能即将上线')),
          ],
        ),
      ),
    );
  }
}

class _TeamInfo extends StatelessWidget {
  const _TeamInfo({
    required this.name,
    required this.logoText,
    this.isAway = false,
  });

  final String name;
  final String logoText;
  final bool isAway;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
          child: Text(
            logoText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _EventsTab extends StatelessWidget {
  const _EventsTab({required this.events});

  final List<MatchEvent> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(child: Text('暂无事件'));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _EventRow(event: event);
      },
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.event});

  final MatchEvent event;

  @override
  Widget build(BuildContext context) {
    final iconData = switch (event.type) {
      'goal' => Icons.sports_soccer,
      'yellow' => Icons.rectangle_outlined,
      'red' => Icons.rectangle,
      'substitution' => Icons.swap_horiz_rounded,
      _ => Icons.circle_outlined,
    };

    final iconColor = switch (event.type) {
      'goal' => const Color(0xFFF59E0B),
      'yellow' => const Color(0xFFF59E0B),
      'red' => const Color(0xFFEF4444),
      _ => null,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              event.displayMinute,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(iconData, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              event.playerName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (event.scoreAfter != null)
            Text(
              event.scoreAfter!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
        ],
      ),
    );
  }
}

class _StatisticsTab extends StatelessWidget {
  const _StatisticsTab({required this.statistics});

  final MatchStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final items = <_StatItem>[
      _StatItem(label: '控球率', home: statistics.possessionHome, away: statistics.possessionAway),
      _StatItem(label: '射门', home: statistics.shotsHome, away: statistics.shotsAway),
      _StatItem(label: '射正', home: statistics.shotsOnTargetHome, away: statistics.shotsOnTargetAway),
      _StatItem(label: '角球', home: statistics.cornersHome, away: statistics.cornersAway),
      _StatItem(label: '犯规', home: statistics.foulsHome, away: statistics.foulsAway),
    ];

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        final homeVal = item.home?.toString() ?? '-';
        final awayVal = item.away?.toString() ?? '-';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  homeVal,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.home != null && item.away != null && (item.home! + item.away!) > 0
                        ? (item.home! / (item.home! + item.away!))
                        : 0.5,
                    minHeight: 8,
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 60,
                child: Text(
                  item.label,
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.home != null && item.away != null && (item.home! + item.away!) > 0
                        ? (item.away! / (item.home! + item.away!))
                        : 0.5,
                    minHeight: 8,
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 40,
                child: Text(
                  awayVal,
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatItem {
  const _StatItem({
    required this.label,
    this.home,
    this.away,
  });

  final String label;
  final int? home;
  final int? away;
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
}
