enum AppFlavor { mock, dev, prod }

class EnvConfig {
  const EnvConfig({
    required this.flavor,
    required this.apiBaseUrl,
    required this.wsBaseUrl,
    required this.featureFlags,
  });

  const EnvConfig.mock()
    : this(
        flavor: AppFlavor.mock,
        apiBaseUrl: 'https://mock.local/api',
        wsBaseUrl: 'wss://mock.local/live',
        featureFlags: const {
          'standings': true,
          'notifications': false,
          'news': false,
          'multiSport': false,
        },
      );

  const EnvConfig.dev()
    : this(
        flavor: AppFlavor.dev,
        apiBaseUrl: 'https://dev.example.com/api',
        wsBaseUrl: 'wss://dev.example.com/live',
        featureFlags: const {
          'standings': true,
          'notifications': false,
          'news': false,
          'multiSport': false,
        },
      );

  const EnvConfig.prod()
    : this(
        flavor: AppFlavor.prod,
        apiBaseUrl: 'https://api.example.com',
        wsBaseUrl: 'wss://api.example.com/live',
        featureFlags: const {
          'standings': true,
          'notifications': false,
          'news': false,
          'multiSport': false,
        },
      );

  final AppFlavor flavor;
  final String apiBaseUrl;
  final String wsBaseUrl;
  final Map<String, bool> featureFlags;
}
