import 'league.dart';
import 'match_status.dart';
import 'score.dart';
import 'team.dart';

class Match {
  const Match({
    required this.id,
    required this.league,
    required this.homeTeam,
    required this.awayTeam,
    required this.status,
    required this.kickoffAt,
    required this.score,
    required this.venue,
    required this.round,
    this.elapsed,
    this.homeRedCards = 0,
    this.awayRedCards = 0,
    this.isFeatured = false,
  });

  final String id;
  final League league;
  final Team homeTeam;
  final Team awayTeam;
  final MatchStatus status;
  final DateTime kickoffAt;
  final int? elapsed;
  final Score score;
  final String venue;
  final String round;
  final int homeRedCards;
  final int awayRedCards;
  final bool isFeatured;
}
