import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/models/match.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({
    required this.match,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
    super.key,
  });

  final Match match;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final textTheme = Theme.of(context).textTheme;
    final homeScore = match.score.home?.toString() ?? '-';
    final awayScore = match.score.away?.toString() ?? '-';

    return Card(
      color: cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${match.league.name} · ${match.round}',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${Formatters.kickoffFormat.format(match.kickoffAt)} · ${match.venue}',
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onFavoriteTap,
                    icon: Icon(
                      isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: isFavorite
                          ? const Color(0xFFF59E0B)
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _TeamColumn(teamText: match.homeTeam.shortName)),
                  Text(
                    '$homeScore  -  $awayScore',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Expanded(child: _TeamColumn(teamText: match.awayTeam.shortName)),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  StatusBadge(status: match.status, elapsed: match.elapsed),
                  if (match.homeRedCards > 0 || match.awayRedCards > 0) ...[
                    const SizedBox(width: 10),
                    Text(
                      '红牌 ${match.homeRedCards}-${match.awayRedCards}',
                      style: textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFEF4444),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamColumn extends StatelessWidget {
  const _TeamColumn({required this.teamText});

  final String teamText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(
            alpha: 0.15,
          ),
          child: Text(
            teamText.characters.take(2).toString(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          teamText,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
