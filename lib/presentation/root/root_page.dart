import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../favorites/favorites_page.dart';
import '../home/home_page.dart';
import '../settings/settings_page.dart';
import '../standings/standings_page.dart';
import 'root_controller.dart';

class RootPage extends GetView<RootController> {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RootController>(
      builder: (ctrl) => Scaffold(
        body: IndexedStack(
          index: ctrl.currentIndex,
          children: const [
            HomePage(),
            StandingsPage(),
            FavoritesPage(),
            SettingsPage(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: ctrl.currentIndex,
          onDestinationSelected: ctrl.changeTab,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: '首页',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_outlined),
              selectedIcon: Icon(Icons.bar_chart_rounded),
              label: '赛事',
            ),
            NavigationDestination(
              icon: Icon(Icons.star_outline_rounded),
              selectedIcon: Icon(Icons.star_rounded),
              label: '关注',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: '我的',
            ),
          ],
        ),
      ),
    );
  }
}
