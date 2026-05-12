// UI Bindings for all pages

import 'package:get/get.dart';
import '../home/home_controller.dart';
import '../standings/standings_controller.dart';
import '../favorites/favorites_controller.dart';
import '../settings/settings_controller.dart';

void initUIBindings() {
  Get.put(HomeController(sportsRepository: Get.find()), permanent: true);
  Get.put(StandingsController(sportsRepository: Get.find()), permanent: true);
  Get.put(FavoritesController(favoritesRepository: Get.find(), sportsRepository: Get.find()), permanent: true);
  Get.put(SettingsController(settingsRepository: Get.find()), permanent: true);
}