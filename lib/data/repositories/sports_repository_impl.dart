import 'package:dio/dio.dart';

import '../../domain/models/match.dart';
import '../../domain/models/match_detail.dart';
import '../../domain/models/sport_type.dart';
import '../../domain/models/standing_row.dart';
import '../../domain/repositories/sports_repository.dart';
import '../api/api_client.dart';

class SportsRepositoryImpl implements SportsRepository {
  SportsRepositoryImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<List<Match>> getAllFixtures() async {
    try {
      final data = await apiClient.get('/matches');
      return data.map<Match>((json) => Match.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load all fixtures: $e');
    }
  }

  @override
  Future<List<Match>> getFixtures({required DateTime date, required SportType sportType}) async {
    try {
      final data = await apiClient.get('/matches', queryParameters: {
        'date': date.toIso8601String(),
        'sportType': sportType.name,
      });
      return data.map<Match>((json) => Match.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load fixtures: $e');
    }
  }

  @override
  Future<MatchDetail> getMatchDetail(String matchId) async {
    try {
      final data = await apiClient.get('/matches/$matchId');
      return MatchDetail.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load match detail: $e');
    }
  }

  @override
  Future<List<StandingRow>> getStandings({required String leagueId, required int season}) async {
    try {
      final data = await apiClient.get('/standings', queryParameters: {
        'leagueId': leagueId,
        'season': season,
      });
      return data.map<StandingRow>((json) => StandingRow.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load standings: $e');
    }
  }
}