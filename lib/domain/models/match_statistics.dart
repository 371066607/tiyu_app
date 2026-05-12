class MatchStatistics {
  const MatchStatistics({
    required this.matchId,
    this.possessionHome,
    this.possessionAway,
    this.shotsHome,
    this.shotsAway,
    this.shotsOnTargetHome,
    this.shotsOnTargetAway,
    this.cornersHome,
    this.cornersAway,
    this.foulsHome,
    this.foulsAway,
  });

  final String matchId;
  final int? possessionHome;
  final int? possessionAway;
  final int? shotsHome;
  final int? shotsAway;
  final int? shotsOnTargetHome;
  final int? shotsOnTargetAway;
  final int? cornersHome;
  final int? cornersAway;
  final int? foulsHome;
  final int? foulsAway;
}
