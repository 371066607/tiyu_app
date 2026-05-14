import 'package:get/get.dart';

import '../../presentation/match_detail/match_detail_controller.dart';
import '../../presentation/match_detail/match_detail_page.dart';
import '../../presentation/root/root_page.dart';
import '../../presentation/settings/privacy_page.dart';

abstract class AppRoutes {
  static const root = '/';
  static const matchDetail = '/match';
  static const privacy = '/privacy';
  static const matchIdParam = 'matchId';
}

class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage<dynamic>(name: AppRoutes.root, page: () => const RootPage()),
    GetPage<dynamic>(
      name: AppRoutes.matchDetail,
      page: () => const MatchDetailPage(),
      binding: BindingsBuilder(() {
        final matchId = Get.parameters[AppRoutes.matchIdParam];
        if (matchId == null || matchId.isEmpty) {
          return;
        }

        Get.lazyPut<MatchDetailController>(
          () => MatchDetailController.create(matchId),
          tag: matchId,
        );
      }),
    ),
    GetPage<dynamic>(name: AppRoutes.privacy, page: () => const PrivacyPage()),
  ];
}
