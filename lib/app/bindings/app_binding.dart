import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/config/env_config.dart';
import '../../data/repositories/local_favorites_repository.dart';
import '../../data/repositories/local_settings_repository.dart';
import '../../data/repositories/mock_sports_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/sports_repository.dart';
import '../../presentation/favorites/favorites_controller.dart';
import '../../presentation/home/home_controller.dart';
import '../../presentation/root/root_controller.dart';
import '../../presentation/settings/settings_controller.dart';
import '../../presentation/standings/standings_controller.dart';

class AppBinding {
  Future<void> dependencies(EnvConfig config) async {
    final storage = GetStorage();

    Get.put<EnvConfig>(config, permanent: true);
    Get.put<SportsRepository>(MockSportsRepository(), permanent: true);
    Get.put<FavoritesRepository>(
      LocalFavoritesRepository(storage),
      permanent: true,
    );
    Get.put<SettingsRepository>(
      LocalSettingsRepository(storage),
      permanent: true,
    );

    final settingsController = Get.put(
      SettingsController(Get.find<SettingsRepository>()),
      permanent: true,
    );
    await settingsController.loadSettings();

    final favoritesController = Get.put(
      FavoritesController(
        favoritesRepository: Get.find<FavoritesRepository>(),
        sportsRepository: Get.find<SportsRepository>(),
      ),
      permanent: true,
    );
    await favoritesController.loadFavorites();

    Get.put(RootController(), permanent: true);
    Get.put(HomeController(sportsRepository: Get.find()), permanent: true);
    Get.put(StandingsController(sportsRepository: Get.find()), permanent: true);
  }
}
