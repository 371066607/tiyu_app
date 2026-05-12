import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/app_theme.dart';
import '../presentation/settings/settings_controller.dart';
import 'routes/app_pages.dart';

class SportsApp extends GetView<SettingsController> {
  const SportsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: '实时赛事',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: controller.themeMode,
        initialRoute: AppRoutes.root,
        getPages: AppPages.pages,
      ),
    );
  }
}
