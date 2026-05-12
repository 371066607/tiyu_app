import 'package:get/get.dart';

import '../../domain/models/match.dart';
import '../../domain/models/match_status.dart';
import '../../domain/models/sport_type.dart';
import '../../domain/repositories/sports_repository.dart';

enum HomeCategory { recommended, football, basketball, esports }

extension HomeCategoryX on HomeCategory {
  String get label => switch (this) {
    HomeCategory.recommended => '推荐',
    HomeCategory.football => '足球',
    HomeCategory.basketball => '篮球',
    HomeCategory.esports => '电竞',
  };

  SportType get sportType => switch (this) {
    HomeCategory.recommended => SportType.football,
    HomeCategory.football => SportType.football,
    HomeCategory.basketball => SportType.basketball,
    HomeCategory.esports => SportType.esports,
  };
}

class HomeController extends GetxController with StateMixin<List<Match>> {
  HomeController({required this.sportsRepository});

  final SportsRepository sportsRepository;
  final selectedCategory = HomeCategory.recommended.obs;
  final selectedDate = DateTime.now().obs;
  final lastUpdated = DateTime.now().obs;
  final availableDates = <DateTime>[].obs;

  @override
  void onInit() {
    super.onInit();
    final base = DateTime.now();
    availableDates.assignAll(
      List<DateTime>.generate(
        5,
        (index) => DateTime(base.year, base.month, base.day + index - 1),
      ),
    );
    selectedDate.value = availableDates[1];
    loadFixtures();
  }

  Future<void> loadFixtures() async {
    change(null, status: RxStatus.loading());

    try {
      final matches = await sportsRepository.getFixtures(
        date: selectedDate.value,
        sportType: selectedCategory.value.sportType,
      );
      final sorted = matches.toList()..sort(_sortMatches);
      lastUpdated.value = DateTime.now();
      change(
        sorted,
        status: sorted.isEmpty ? RxStatus.empty() : RxStatus.success(),
      );
    } catch (error) {
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  Future<void> selectCategory(HomeCategory category) async {
    selectedCategory.value = category;
    await loadFixtures();
  }

  Future<void> selectDate(DateTime date) async {
    selectedDate.value = date;
    await loadFixtures();
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

    final fullTimeWeightA = a.status == MatchStatus.fullTime ? 1 : 0;
    final fullTimeWeightB = b.status == MatchStatus.fullTime ? 1 : 0;
    if (fullTimeWeightA != fullTimeWeightB) {
      return fullTimeWeightA.compareTo(fullTimeWeightB);
    }

    return a.kickoffAt.compareTo(b.kickoffAt);
  }
}
