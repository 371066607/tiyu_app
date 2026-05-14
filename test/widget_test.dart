import 'package:flutter_test/flutter_test.dart';

import 'package:tiyu_app/domain/models/match.dart';
import 'package:tiyu_app/domain/models/league.dart';
import 'package:tiyu_app/domain/models/team.dart';
import 'package:tiyu_app/domain/models/score.dart';
import 'package:tiyu_app/domain/models/match_status.dart';
import 'package:tiyu_app/domain/models/match_event.dart';
import 'package:tiyu_app/domain/models/match_statistics.dart';
import 'package:tiyu_app/domain/models/standing_row.dart';
import 'package:tiyu_app/domain/models/sport_type.dart';
import 'package:tiyu_app/domain/models/app_settings.dart';
import 'package:tiyu_app/domain/models/match_detail.dart';
import 'package:flutter/material.dart';
import 'package:tiyu_app/domain/services/notification_service.dart';

void main() {
  group('Match model', () {
    test('creates Match with all fields', () {
      final league = const League(
        id: 'pl',
        name: '英超',
        country: '英格兰',
        season: 2024,
      );
      final team = const Team(
        id: 'mci',
        name: '曼城',
        shortName: '曼城',
        logoText: 'MC',
      );
      final score = const Score(home: 2, away: 1);
      final match = Match(
        id: 'm1',
        league: league,
        homeTeam: team,
        awayTeam: team,
        status: MatchStatus.live,
        kickoffAt: DateTime(2024, 1, 1),
        score: score,
        venue: '球场',
        round: '第1轮',
        elapsed: 45,
      );

      expect(match.id, 'm1');
      expect(match.status, MatchStatus.live);
      expect(match.score.home, 2);
    });
  });

  group('MatchStatus mapping', () {
    test('maps raw status correctly', () {
      expect(MatchStatusMapper.fromRaw('live'), MatchStatus.live);
      expect(MatchStatusMapper.fromRaw('in_progress'), MatchStatus.live);
      expect(MatchStatusMapper.fromRaw('ht'), MatchStatus.halfTime);
      expect(MatchStatusMapper.fromRaw('ft'), MatchStatus.fullTime);
      expect(MatchStatusMapper.fromRaw('finished'), MatchStatus.fullTime);
      expect(MatchStatusMapper.fromRaw('ns'), MatchStatus.scheduled);
      expect(MatchStatusMapper.fromRaw('postponed'), MatchStatus.postponed);
      expect(MatchStatusMapper.fromRaw('cancelled'), MatchStatus.cancelled);
      expect(MatchStatusMapper.fromRaw('suspended'), MatchStatus.suspended);
      expect(MatchStatusMapper.fromRaw('unknown_string'), MatchStatus.unknown);
      expect(MatchStatusMapper.fromRaw(null), MatchStatus.unknown);
    });

    test('isLive returns correct value', () {
      expect(MatchStatus.live.isLive, true);
      expect(MatchStatus.halfTime.isLive, true);
      expect(MatchStatus.scheduled.isLive, false);
      expect(MatchStatus.fullTime.isLive, false);
    });
  });

  group('MatchEvent', () {
    test('displayMinute returns correct format', () {
      final event = const MatchEvent(
        eventId: 'e1',
        matchId: 'm1',
        type: 'goal',
        minute: 45,
        teamId: 't1',
        playerName: 'Player',
        sequence: 1,
      );
      expect(event.displayMinute, "45'");
    });

    test('displayMinute includes extra minute', () {
      final event = const MatchEvent(
        eventId: 'e2',
        matchId: 'm1',
        type: 'goal',
        minute: 90,
        extraMinute: 3,
        teamId: 't1',
        playerName: 'Player',
        sequence: 2,
      );
      expect(event.displayMinute, "90+3'");
    });
  });

  group('StandingRow', () {
    test('creates StandingRow correctly', () {
      const team = Team(
        id: 't1', name: 'Team', shortName: 'T', logoText: 'T',
      );
      const row = StandingRow(
        rank: 1,
        team: team,
        played: 10,
        won: 8,
        draw: 1,
        lost: 1,
        goalDiff: 20,
        points: 25,
      );
      expect(row.rank, 1);
      expect(row.points, 25);
    });
  });

  group('AppSettings', () {
    test('defaults create correct values', () {
      final settings = const AppSettings.defaults();
      expect(settings.allowNotifications, false);
      expect(settings.goalNotifications, true);
    });

    test('copyWith updates fields', () {
      final settings = const AppSettings.defaults().copyWith(
        allowNotifications: true,
      );
      expect(settings.allowNotifications, true);
      expect(settings.goalNotifications, true);
    });
  });

  group('MatchStatistics', () {
    test('creates with nullable fields', () {
      final stats = const MatchStatistics(matchId: 'm1');
      expect(stats.matchId, 'm1');
      expect(stats.possessionHome, isNull);
    });
  });

  group('SportType', () {
    test('labels are correct', () {
      expect(SportType.football.label, '足球');
      expect(SportType.basketball.label, '篮球');
      expect(SportType.esports.label, '电竞');
    });
  });

  group('MatchDetail', () {
    test('creates MatchDetail correctly', () {
      final match = Match(
        id: 'm1',
        league: const League(id: 'l1', name: 'L', country: 'C', season: 2024),
        homeTeam: const Team(id: 't1', name: 'A', shortName: 'A', logoText: 'A'),
        awayTeam: const Team(id: 't2', name: 'B', shortName: 'B', logoText: 'B'),
        status: MatchStatus.live,
        kickoffAt: DateTime(2024, 1, 1),
        score: const Score(),
        venue: 'V',
        round: 'R1',
      );
      final detail = MatchDetail(
        match: match,
        events: const [],
        statistics: const MatchStatistics(matchId: 'm1'),
        headline: 'Test',
      );
      expect(detail.match.id, 'm1');
      expect(detail.headline, 'Test');
      expect(detail.events, isEmpty);
    });
  });

  group('NotificationService', () {
    test('shouldNotify respects settings', () {
      final service = _FakeNotificationService();
      final settings = const AppSettings.defaults();

      expect(service.shouldNotify(settings, 'goal'), false);

      final enabled = settings.copyWith(allowNotifications: true);
      expect(service.shouldNotify(enabled, 'goal'), true);
      expect(service.shouldNotify(enabled, 'redCard'), true);
      expect(service.shouldNotify(enabled, 'kickoff'), true);

      final goalOff = enabled.copyWith(goalNotifications: false);
      expect(service.shouldNotify(goalOff, 'goal'), false);
      expect(service.shouldNotify(goalOff, 'redCard'), true);
    });

    test('AppSettings.shouldNotifyFor checks settings correctly', () {
      final settings = AppSettings(
        themeMode: ThemeMode.system,
        allowNotifications: true,
        goalNotifications: false,
        redCardNotifications: true,
        kickoffNotifications: false,
      );

      expect(settings.shouldNotifyFor('goal'), false);
      expect(settings.shouldNotifyFor('redCard'), true);
      expect(settings.shouldNotifyFor('kickoff'), false);
      expect(settings.shouldNotifyFor('unknown'), false);

      final disabled = settings.copyWith(allowNotifications: false);
      expect(disabled.shouldNotifyFor('redCard'), false);
    });
  });
}

class _FakeNotificationService implements NotificationService {
  @override
  Future<NotificationPermission> get permission async =>
      NotificationPermission.granted;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Future<void> showMatchNotification({
    String? matchId,
    String? title,
    String? body,
    String? payload,
  }) async {}

  @override
  Future<void> showGoalNotification({
    String? matchId,
    String? homeTeam,
    String? awayTeam,
    String? scorer,
    String? score,
  }) async {}

  @override
  Future<void> showKickoffNotification({
    String? matchId,
    String? homeTeam,
    String? awayTeam,
  }) async {}

  @override
  Future<void> showRedCardNotification({
    String? matchId,
    String? team,
    String? player,
  }) async {}

  @override
  Future<void> cancelMatchNotifications(String matchId) async {}

  @override
  bool shouldNotify(AppSettings settings, String eventType) {
    return settings.shouldNotifyFor(eventType);
  }
}
