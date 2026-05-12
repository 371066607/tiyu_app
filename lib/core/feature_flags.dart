class FeatureFlags {
  static bool enableDarkMode = false;
  static bool enableAdvancedStats = true;
  static bool enableLiveNotifications = true;

  static void updateFlag(String key, bool value) {
    switch (key) {
      case 'enableDarkMode':
        enableDarkMode = value;
        break;
      case 'enableAdvancedStats':
        enableAdvancedStats = value;
        break;
      case 'enableLiveNotifications':
        enableLiveNotifications = value;
        break;
    }
  }
}