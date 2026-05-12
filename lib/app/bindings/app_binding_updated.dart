import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/config/env_config.dart';
import '../../data/repositories/sports_repository_impl.dart';
import '../../domain/repositories/sports_repository.dart';
import '../../presentation/home/home_controller.dart';
import '../../presentation/standings/standings_controller.dart';
import '../../services/websocket_service.dart';

class AppBindingUpdated {
  Future<void> dependencies(EnvConfig config) async {
    final storage = GetStorage();

    // Inject environment
    Get.put<EnvConfig>(config, permanent: true);

    // Inject real repository
    final apiClient = ApiClient(baseUrl: config.apiBaseUrl);
    final sportsRepo = SportsRepositoryImpl(apiClient: apiClient);
    Get.put<SportsRepository>(sportsRepo, permanent: true);

    // WebSocket service
    final wsService = WebSocketService(url: config.wsBaseUrl);
    wsService.connect();
    Get.put(wsService, permanent: true);

    // Controllers
    final homeController = Get.put(HomeController(sportsRepository: sportsRepo), permanent: true);
    final standingsController = Get.put(StandingsController(sportsRepository: sportsRepo), permanent: true);
  }
}