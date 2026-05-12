class MatchEvent {
  const MatchEvent({
    required this.eventId,
    required this.matchId,
    required this.type,
    required this.minute,
    required this.teamId,
    required this.playerName,
    required this.sequence,
    this.extraMinute,
    this.assistName,
    this.scoreAfter,
  });

  final String eventId;
  final String matchId;
  final String type;
  final int minute;
  final int? extraMinute;
  final String teamId;
  final String playerName;
  final String? assistName;
  final String? scoreAfter;
  final int sequence;

  String get displayMinute =>
      extraMinute == null ? '$minute\'' : '$minute+$extraMinute\'';
}
