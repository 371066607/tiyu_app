import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/config/env_config.dart';
import '../../data/api/api_client.dart';
import '../../data/repositories/local_favorites_repository.dart';
import '../../data/repositories/local_settings_repository.dart';
import '../../data/repositories/mock_sports_repository.dart';
import '../../data/repositories/sports_repository_impl.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/sports_repository.dart';
import '../../domain/services/notification_service.dart';
import '../../presentation/favorites/favorites_controller.dart';
import '../../presentation/home/home_controller.dart';
import '../../presentation/root/root_controller.dart';
import '../../presentation/settings/settings_controller.dart';
import '../../presentation/standings/standings_controller.dart';
import '../../services/local_notification_service.dart';

class AppBinding {
  Future<void> dependencies(EnvConfig config) async {
    final storage = GetStorage();

    Get.put<EnvConfig>(config, permanent: true);
    final sportsRepository = config.useMockData
        ? MockSportsRepository()
        : SportsRepositoryImpl(apiClient: ApiClient(config));

    Get.put<SportsRepository>(sportsRepository, permanent: true);
    Get.put<FavoritesRepository>(
      LocalFavoritesRepository(storage),
      permanent: true,
    );
    Get.put<SettingsRepository>(
      LocalSettingsRepository(storage),
      permanent: true,
    );
    Get.put<NotificationService>(
      LocalNotificationService(),
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
