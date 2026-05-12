import 'package:get/get.dart';

import '../../domain/models/standing_row.dart';
import '../../domain/repositories/sports_repository.dart';

class StandingsController extends GetxController with StateMixin<List<StandingRow>> {
  StandingsController({required this.sportsRepository});

  final SportsRepository sportsRepository;

  @override
  void onInit() {
    super.onInit();
    loadStandings();
  }

  Future<void> loadStandings() async {
    change(null, status: RxStatus.loading());
    try {
      final rows = await sportsRepository.getStandings(
        leagueId: 'pl',
        season: 2024,
      );
      change(rows, status: rows.isEmpty ? RxStatus.empty() : RxStatus.success());
    } catch (error) {
      change(null, status: RxStatus.error(error.toString()));
    }
  }
}
