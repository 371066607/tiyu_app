import '../models/match.dart';
import '../models/match_detail.dart';
import '../models/sport_type.dart';
import '../models/standing_row.dart';

abstract class SportsRepository {
  Future<List<Match>> getFixtures({
    required DateTime date,
    required SportType sportType,
  });

  Future<List<Match>> getAllFixtures();

  Future<MatchDetail> getMatchDetail(String matchId);

  Future<List<StandingRow>> getStandings({
    required String leagueId,
    required int season,
  });
}
