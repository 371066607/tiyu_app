import 'package:get/get.dart';

import '../../domain/models/match.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/sports_repository.dart';
import '../../domain/services/notification_service.dart';

class FavoritesController extends GetxController with StateMixin<List<Match>> {
  FavoritesController({
    required this.favoritesRepository,
    required this.sportsRepository,
  });

  final FavoritesRepository favoritesRepository;
  final SportsRepository sportsRepository;
  final favoriteIds = <String>{}.obs;

  late final NotificationService _notificationService;
  late final SettingsRepository _settingsRepository;

  @override
  void onInit() {
    super.onInit();
    _notificationService = Get.find<NotificationService>();
    _settingsRepository = Get.find<SettingsRepository>();
  }

  Future<void> loadFavorites() async {
    change(null, status: RxStatus.loading());

    try {
      favoriteIds
        ..clear()
        ..addAll(await favoritesRepository.loadFavoriteMatchIds());

      final matches = await sportsRepository.getAllFixtures();
      final favorites = matches
          .where((match) => favoriteIds.contains(match.id))
          .toList()
        ..sort((left, right) => right.kickoffAt.compareTo(left.kickoffAt));

      change(
        favorites,
        status: favorites.isEmpty ? RxStatus.empty() : RxStatus.success(),
      );
    } catch (error) {
      change(null, status: RxStatus.error(error.toString()));
    }
  }

  bool isFavorite(String matchId) => favoriteIds.contains(matchId);

  Future<void> toggleFavorite(String matchId) async {
    if (favoriteIds.contains(matchId)) {
      favoriteIds.remove(matchId);
    } else {
      favoriteIds.add(matchId);
    }

    await favoritesRepository.saveFavoriteMatchIds(favoriteIds.toSet());
    await loadFavorites();
  }

  Future<void> testNotification(Match match) async {
    final settings = await _settingsRepository.loadSettings();
    if (!settings.allowNotifications) return;

    await _notificationService.showKickoffNotification(
      matchId: match.id,
      homeTeam: match.homeTeam.name,
      awayTeam: match.awayTeam.name,
    );
  }
}
