import '../../domain/models/league.dart';
import '../../domain/models/match.dart';
import '../../domain/models/match_detail.dart';
import '../../domain/models/match_event.dart';
import '../../domain/models/match_statistics.dart';
import '../../domain/models/match_status.dart';
import '../../domain/models/score.dart';
import '../../domain/models/sport_type.dart';
import '../../domain/models/standing_row.dart';
import '../../domain/models/team.dart';
import '../../domain/repositories/sports_repository.dart';
import '../api/api_client.dart';

class SportsRepositoryImpl implements SportsRepository {
  SportsRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<List<Match>> getAllFixtures() async {
    final data = await apiClient.get('/matches');
    return _asList(data).map(_matchFromJson).toList();
  }

  @override
  Future<List<Match>> getFixtures({
    required DateTime date,
    required SportType sportType,
  }) async {
    final data = await apiClient.get(
      '/matches',
      queryParameters: <String, dynamic>{
        'date': _dateOnly(date),
        'sportType': sportType.name,
      },
    );
    return _asList(data).map(_matchFromJson).toList();
  }

  @override
  Future<MatchDetail> getMatchDetail(String matchId) async {
    final data = await apiClient.get('/matches/$matchId');
    return _matchDetailFromJson(_asMap(data));
  }

  @override
  Future<List<StandingRow>> getStandings({
    required String leagueId,
    required int season,
  }) async {
    final data = await apiClient.get(
      '/standings',
      queryParameters: <String, dynamic>{
        'leagueId': leagueId,
        'season': season,
      },
    );
    return _asList(data).map(_standingRowFromJson).toList();
  }

  List<Map<String, dynamic>> _asList(dynamic data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    if (data is Map && data['items'] is List) {
      return _asList(data['items']);
    }
    return const <Map<String, dynamic>>[];
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return const <String, dynamic>{};
  }

  Match _matchFromJson(Map<String, dynamic> json) {
    return Match(
      id: _string(json['id'] ?? json['matchId']),
      league: _leagueFromJson(_asMap(json['league'])),
      homeTeam: _teamFromJson(_asMap(json['homeTeam'] ?? json['home'])),
      awayTeam: _teamFromJson(_asMap(json['awayTeam'] ?? json['away'])),
      status: MatchStatusMapper.fromRaw(_string(json['status'])),
      kickoffAt: _dateTime(json['kickoffAt'] ?? json['startTime']),
      elapsed: _intOrNull(json['elapsed'] ?? json['minute']),
      score: _scoreFromJson(_asMap(json['score'])),
      venue: _string(json['venue']),
      round: _string(json['round']),
      homeRedCards: _int(json['homeRedCards']),
      awayRedCards: _int(json['awayRedCards']),
      isFeatured: json['isFeatured'] == true,
    );
  }

  MatchDetail _matchDetailFromJson(Map<String, dynamic> json) {
    final matchJson = _asMap(json['match'].runtimeType == Null ? json : json['match']);
    return MatchDetail(
      match: _matchFromJson(matchJson),
      headline: _string(json['headline']),
      events: _asList(json['events']).map(_eventFromJson).toList(),
      statistics: _statisticsFromJson(_asMap(json['statistics'])),
    );
  }

  StandingRow _standingRowFromJson(Map<String, dynamic> json) {
    return StandingRow(
      rank: _int(json['rank']),
      team: _teamFromJson(_asMap(json['team'])),
      played: _int(json['played']),
      won: _int(json['won']),
      draw: _int(json['draw']),
      lost: _int(json['lost']),
      goalDiff: _int(json['goalDiff'] ?? json['goalDifference']),
      points: _int(json['points']),
    );
  }

  League _leagueFromJson(Map<String, dynamic> json) {
    return League(
      id: _string(json['id']),
      name: _string(json['name']),
      country: _string(json['country']),
      season: _int(json['season']),
      sportType: SportType.football,
    );
  }

  Team _teamFromJson(Map<String, dynamic> json) {
    return Team(
      id: _string(json['id']),
      name: _string(json['name']),
      shortName: _string(json['shortName'] ?? json['short_name'] ?? json['name']),
      logoText: _string(json['logoText'] ?? json['shortName'] ?? json['name']),
    );
  }

  Score _scoreFromJson(Map<String, dynamic> json) {
    return Score(
      home: _intOrNull(json['home']),
      away: _intOrNull(json['away']),
      halfTimeHome: _intOrNull(json['halfTimeHome']),
      halfTimeAway: _intOrNull(json['halfTimeAway']),
    );
  }

  MatchEvent _eventFromJson(Map<String, dynamic> json) {
    return MatchEvent(
      eventId: _string(json['eventId'] ?? json['id']),
      matchId: _string(json['matchId']),
      type: _string(json['type']),
      minute: _int(json['minute']),
      extraMinute: _intOrNull(json['extraMinute']),
      teamId: _string(json['teamId']),
      playerName: _string(json['playerName']),
      assistName: _stringOrNull(json['assistName']),
      scoreAfter: _stringOrNull(json['scoreAfter']),
      sequence: _int(json['sequence']),
    );
  }

  MatchStatistics _statisticsFromJson(Map<String, dynamic> json) {
    return MatchStatistics(
      matchId: _string(json['matchId']),
      possessionHome: _intOrNull(json['possessionHome']),
      possessionAway: _intOrNull(json['possessionAway']),
      shotsHome: _intOrNull(json['shotsHome']),
      shotsAway: _intOrNull(json['shotsAway']),
      shotsOnTargetHome: _intOrNull(json['shotsOnTargetHome']),
      shotsOnTargetAway: _intOrNull(json['shotsOnTargetAway']),
      cornersHome: _intOrNull(json['cornersHome']),
      cornersAway: _intOrNull(json['cornersAway']),
      foulsHome: _intOrNull(json['foulsHome']),
      foulsAway: _intOrNull(json['foulsAway']),
    );
  }

  String _dateOnly(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  DateTime _dateTime(dynamic value) {
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  int _int(dynamic value) => _intOrNull(value) ?? 0;

  int? _intOrNull(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  String _string(dynamic value) => value?.toString() ?? '';

  String? _stringOrNull(dynamic value) => value?.toString();
}
