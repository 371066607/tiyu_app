import 'match.dart';
import 'match_event.dart';
import 'match_statistics.dart';

class MatchDetail {
  const MatchDetail({
    required this.match,
    required this.events,
    required this.statistics,
    required this.headline,
  });

  final Match match;
  final List<MatchEvent> events;
  final MatchStatistics statistics;
  final String headline;
}
