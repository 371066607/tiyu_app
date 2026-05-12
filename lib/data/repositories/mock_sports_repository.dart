import 'package:collection/collection.dart';

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

class MockSportsRepository implements SportsRepository {
  MockSportsRepository() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));

    const premierLeague = League(
      id: 'pl',
      name: '英超联赛',
      country: '英格兰',
      season: 2024,
    );
    const laLiga = League(
      id: 'laliga',
      name: '西甲联赛',
      country: '西班牙',
      season: 2024,
    );

    const manCity = Team(
      id: 'mci',
      name: '曼彻斯特城',
      shortName: '曼城',
      logoText: 'MC',
    );
    const arsenal = Team(
      id: 'ars',
      name: '阿森纳',
      shortName: '阿森纳',
      logoText: 'AR',
    );
    const inter = Team(
      id: 'int',
      name: '国际米兰',
      shortName: '国米',
      logoText: 'IM',
    );
    const acMilan = Team(
      id: 'acm',
      name: 'AC米兰',
      shortName: '米兰',
      logoText: 'AM',
    );
    const realMadrid = Team(
      id: 'rm',
      name: '皇家马德里',
      shortName: '皇马',
      logoText: 'RM',
    );
    const barcelona = Team(
      id: 'bar',
      name: '巴塞罗那',
      shortName: '巴萨',
      logoText: 'BA',
    );
    const liverpool = Team(
      id: 'liv',
      name: '利物浦',
      shortName: '利物浦',
      logoText: 'LIV',
    );
    const tottenham = Team(
      id: 'tot',
      name: '托特纳姆热刺',
      shortName: '热刺',
      logoText: 'TOT',
    );
    const newcastle = Team(
      id: 'new',
      name: '纽卡斯尔联',
      shortName: '纽卡',
      logoText: 'NEW',
    );
    const chelsea = Team(
      id: 'che',
      name: '切尔西',
      shortName: '切尔西',
      logoText: 'CHE',
    );

    _fixtures = <Match>[
      Match(
        id: 'match_001',
        league: premierLeague,
        homeTeam: manCity,
        awayTeam: arsenal,
        status: MatchStatus.live,
        kickoffAt: today.add(const Duration(hours: 20)),
        elapsed: 78,
        score: const Score(home: 2, away: 1, halfTimeHome: 1, halfTimeAway: 1),
        venue: '伊蒂哈德球场',
        round: '第32轮',
        isFeatured: true,
      ),
      Match(
        id: 'match_002',
        league: premierLeague,
        homeTeam: newcastle,
        awayTeam: chelsea,
        status: MatchStatus.live,
        kickoffAt: today.add(const Duration(hours: 18, minutes: 30)),
        elapsed: 65,
        score: const Score(home: 1, away: 1),
        venue: '圣詹姆斯公园',
        round: '第32轮',
      ),
      Match(
        id: 'match_003',
        league: laLiga,
        homeTeam: realMadrid,
        awayTeam: barcelona,
        status: MatchStatus.scheduled,
        kickoffAt: today.add(const Duration(hours: 23)),
        score: const Score(),
        venue: '伯纳乌球场',
        round: '国家德比',
        isFeatured: true,
      ),
      Match(
        id: 'match_004',
        league: premierLeague,
        homeTeam: liverpool,
        awayTeam: tottenham,
        status: MatchStatus.fullTime,
        kickoffAt: yesterday.add(const Duration(hours: 21)),
        score: const Score(home: 3, away: 2),
        venue: '安菲尔德球场',
        round: '第31轮',
      ),
      Match(
        id: 'match_005',
        league: premierLeague,
        homeTeam: acMilan,
        awayTeam: inter,
        status: MatchStatus.scheduled,
        kickoffAt: tomorrow.add(const Duration(hours: 19)),
        score: const Score(),
        venue: '圣西罗球场',
        round: '焦点战',
      ),
    ];

    _details = <String, MatchDetail>{
      'match_001': MatchDetail(
        match: _fixtures.firstWhere((match) => match.id == 'match_001'),
        headline: '曼城控球占优，阿森纳反击威胁十足，比赛进入最后十分钟。',
        events: const [
          MatchEvent(
            eventId: 'e1',
            matchId: 'match_001',
            type: 'goal',
            minute: 12,
            teamId: 'mci',
            playerName: '哈兰德',
            scoreAfter: '1-0',
            sequence: 1,
          ),
          MatchEvent(
            eventId: 'e2',
            matchId: 'match_001',
            type: 'goal',
            minute: 45,
            teamId: 'ars',
            playerName: '厄德高',
            scoreAfter: '1-1',
            sequence: 2,
          ),
          MatchEvent(
            eventId: 'e3',
            matchId: 'match_001',
            type: 'yellow',
            minute: 59,
            teamId: 'ars',
            playerName: '赖斯',
            sequence: 3,
          ),
          MatchEvent(
            eventId: 'e4',
            matchId: 'match_001',
            type: 'substitution',
            minute: 65,
            teamId: 'mci',
            playerName: '阿尔瓦雷斯',
            assistName: '德布劳内',
            sequence: 4,
          ),
          MatchEvent(
            eventId: 'e5',
            matchId: 'match_001',
            type: 'goal',
            minute: 78,
            teamId: 'mci',
            playerName: '福登',
            scoreAfter: '2-1',
            sequence: 5,
          ),
        ],
        statistics: const MatchStatistics(
          matchId: 'match_001',
          possessionHome: 62,
          possessionAway: 38,
          shotsHome: 14,
          shotsAway: 9,
          shotsOnTargetHome: 7,
          shotsOnTargetAway: 4,
          cornersHome: 6,
          cornersAway: 3,
          foulsHome: 8,
          foulsAway: 11,
        ),
      ),
      'match_002': MatchDetail(
        match: _fixtures.firstWhere((match) => match.id == 'match_002'),
        headline: '双方节奏拉满，切尔西依靠边路推进持续制造威胁。',
        events: const [
          MatchEvent(
            eventId: 'e21',
            matchId: 'match_002',
            type: 'goal',
            minute: 18,
            teamId: 'new',
            playerName: '伊萨克',
            scoreAfter: '1-0',
            sequence: 1,
          ),
          MatchEvent(
            eventId: 'e22',
            matchId: 'match_002',
            type: 'goal',
            minute: 41,
            teamId: 'che',
            playerName: '帕尔默',
            scoreAfter: '1-1',
            sequence: 2,
          ),
        ],
        statistics: const MatchStatistics(
          matchId: 'match_002',
          possessionHome: 48,
          possessionAway: 52,
          shotsHome: 10,
          shotsAway: 11,
          shotsOnTargetHome: 3,
          shotsOnTargetAway: 5,
          cornersHome: 4,
          cornersAway: 6,
          foulsHome: 12,
          foulsAway: 9,
        ),
      ),
      'match_003': MatchDetail(
        match: _fixtures.firstWhere((match) => match.id == 'match_003'),
        headline: '赛前焦点：国家德比即将打响，两队争冠形势直接对话。',
        events: const [],
        statistics: const MatchStatistics(matchId: 'match_003'),
      ),
      'match_004': MatchDetail(
        match: _fixtures.firstWhere((match) => match.id == 'match_004'),
        headline: '利物浦在主场完成逆转，热刺后防最后阶段连续失位。',
        events: const [],
        statistics: const MatchStatistics(matchId: 'match_004'),
      ),
      'match_005': MatchDetail(
        match: _fixtures.firstWhere((match) => match.id == 'match_005'),
        headline: '米兰德比预热中，预计首发将在赛前一小时公布。',
        events: const [],
        statistics: const MatchStatistics(matchId: 'match_005'),
      ),
    };

    _standings = const <StandingRow>[
      StandingRow(
        rank: 1,
        team: Team(id: 'mci', name: '曼彻斯特城', shortName: '曼城', logoText: 'MC'),
        played: 32,
        won: 23,
        draw: 6,
        lost: 3,
        goalDiff: 40,
        points: 75,
      ),
      StandingRow(
        rank: 2,
        team: Team(id: 'ars', name: '阿森纳', shortName: '阿森纳', logoText: 'AR'),
        played: 32,
        won: 22,
        draw: 5,
        lost: 5,
        goalDiff: 36,
        points: 71,
      ),
      StandingRow(
        rank: 3,
        team: Team(id: 'liv', name: '利物浦', shortName: '利物浦', logoText: 'LIV'),
        played: 32,
        won: 21,
        draw: 8,
        lost: 3,
        goalDiff: 33,
        points: 71,
      ),
      StandingRow(
        rank: 4,
        team: Team(id: 'tot', name: '托特纳姆热刺', shortName: '热刺', logoText: 'TOT'),
        played: 32,
        won: 18,
        draw: 6,
        lost: 8,
        goalDiff: 16,
        points: 60,
      ),
      StandingRow(
        rank: 5,
        team: Team(id: 'new', name: '纽卡斯尔联', shortName: '纽卡', logoText: 'NEW'),
        played: 32,
        won: 17,
        draw: 5,
        lost: 10,
        goalDiff: 12,
        points: 56,
      ),
    ];
  }

  late final List<Match> _fixtures;
  late final Map<String, MatchDetail> _details;
  late final List<StandingRow> _standings;

  @override
  Future<List<Match>> getAllFixtures() async {
    return List<Match>.from(_fixtures);
  }

  @override
  Future<MatchDetail> getMatchDetail(String matchId) async {
    final detail = _details[matchId];
    if (detail == null) {
      throw Exception('未找到比赛详情');
    }
    return detail;
  }

  @override
  Future<List<Match>> getFixtures({
    required DateTime date,
    required SportType sportType,
  }) async {
    if (sportType != SportType.football) {
      return const <Match>[];
    }

    final target = DateTime(date.year, date.month, date.day);
    return _fixtures.where((match) {
      final kickoff = DateTime(
        match.kickoffAt.year,
        match.kickoffAt.month,
        match.kickoffAt.day,
      );
      return kickoff == target;
    }).sorted(_sortMatches);
  }

  @override
  Future<List<StandingRow>> getStandings({
    required String leagueId,
    required int season,
  }) async {
    return List<StandingRow>.from(_standings);
  }

  int _sortMatches(Match a, Match b) {
    final liveWeightA = a.status.isLive ? 0 : 1;
    final liveWeightB = b.status.isLive ? 0 : 1;
    if (liveWeightA != liveWeightB) {
      return liveWeightA.compareTo(liveWeightB);
    }

    final featuredWeightA = a.isFeatured ? 0 : 1;
    final featuredWeightB = b.isFeatured ? 0 : 1;
    if (featuredWeightA != featuredWeightB) {
      return featuredWeightA.compareTo(featuredWeightB);
    }

    return a.kickoffAt.compareTo(b.kickoffAt);
  }
}
