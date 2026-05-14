import 'package:get/get.dart';

import '../../domain/models/match_detail.dart';
import '../../domain/repositories/sports_repository.dart';

class MatchDetailController extends GetxController
    with StateMixin<MatchDetail> {
  MatchDetailController({
    required this.sportsRepository,
    required this.matchId,
  });

  factory MatchDetailController.create(String matchId) {
    return MatchDetailController(
      sportsRepository: Get.find<SportsRepository>(),
      matchId: matchId,
    );
  }

  final SportsRepository sportsRepository;
  final String matchId;

  @override
  void onInit() {
    super.onInit();
    loadDetail();
  }

  Future<void> loadDetail() async {
    change(null, status: RxStatus.loading());

    try {
      final detail = await sportsRepository.getMatchDetail(matchId);
      change(detail, status: RxStatus.success());
    } catch (error) {
      change(null, status: RxStatus.error(error.toString()));
    }
  }
}
