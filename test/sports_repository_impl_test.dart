import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../lib/data/repositories/sports_repository_impl.dart';
import '../lib/data/api/api_client.dart';
import '../lib/domain/models/match.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late SportsRepositoryImpl repo;
  late MockApiClient client;

  setUp(() {
    client = MockApiClient();
    repo = SportsRepositoryImpl(apiClient: client);
  });

  test('getAllFixtures returns list of matches', () async {
    when(client.get('/matches')).thenAnswer((_) async => [
      {'id': '1', 'homeTeam': 'A', 'awayTeam': 'B', 'kickoffAt': DateTime.now().toIso8601String(), 'status': 'scheduled'}
    ]);

    final matches = await repo.getAllFixtures();
    expect(matches, isA<List<Match>>());
    expect(matches.length, 1);
  });
}