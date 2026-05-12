import 'package:flutter/material.dart';

import '../../domain/models/match_status.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.status,
    required this.elapsed,
    super.key,
  });

  final MatchStatus status;
  final int? elapsed;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      MatchStatus.live => const Color(0xFFEF4444),
      MatchStatus.halfTime => const Color(0xFFF59E0B),
      MatchStatus.fullTime => const Color(0xFF64748B),
      MatchStatus.scheduled => Theme.of(context).colorScheme.primary,
      MatchStatus.postponed || MatchStatus.cancelled || MatchStatus.suspended =>
        const Color(0xFF7C3AED),
      MatchStatus.unknown => const Color(0xFF64748B),
    };

    final label = status == MatchStatus.live && elapsed != null
        ? '$elapsed\''
        : status.label;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
