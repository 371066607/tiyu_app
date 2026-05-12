import 'team.dart';

class StandingRow {
  const StandingRow({
    required this.rank,
    required this.team,
    required this.played,
    required this.won,
    required this.draw,
    required this.lost,
    required this.goalDiff,
    required this.points,
  });

  final int rank;
  final Team team;
  final int played;
  final int won;
  final int draw;
  final int lost;
  final int goalDiff;
  final int points;
}
