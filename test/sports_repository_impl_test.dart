import 'package:flutter_test/flutter_test.dart';

import 'package:tiyu_app/data/repositories/mock_sports_repository.dart';
import 'package:tiyu_app/domain/models/match.dart';
import 'package:tiyu_app/domain/models/standing_row.dart';
import 'package:tiyu_app/domain/models/sport_type.dart';

void main() {
  late MockSportsRepository repository;

  setUp(() {
    repository = MockSportsRepository();
  });

  group('MockSportsRepository', () {
    test('getAllFixtures returns list of matches', () async {
      final matches = await repository.getAllFixtures();
      expect(matches, isA<List<Match>>());
      expect(matches.length, greaterThan(0));
    });

    test('getFixtures returns filtered results by date', () async {
      final today = DateTime.now();
      final matches = await repository.getFixtures(
        date: today,
        sportType: SportType.football,
      );
      expect(matches, isA<List<Match>>());
    });

    test('getFixtures returns empty for non-football sports', () async {
      final today = DateTime.now();
      final matches = await repository.getFixtures(
        date: today,
        sportType: SportType.basketball,
      );
      expect(matches, isEmpty);
    });

    test('getMatchDetail returns detail for valid match', () async {
      final detail = await repository.getMatchDetail('match_001');
      expect(detail.match.id, 'match_001');
      expect(detail.events, isNotEmpty);
      expect(detail.headline, isNotEmpty);
    });

    test('getMatchDetail throws for invalid match', () async {
      expect(
        () => repository.getMatchDetail('invalid_id'),
        throwsException,
      );
    });

    test('getStandings returns list of standings', () async {
      final standings = await repository.getStandings(
        leagueId: 'pl',
        season: 2024,
      );
      expect(standings, isA<List<StandingRow>>());
      expect(standings.length, greaterThan(0));
      expect(standings[0].rank, 1);
    });
  });
}
