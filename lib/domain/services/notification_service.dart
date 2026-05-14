import '../models/app_settings.dart';

enum NotificationPermission { granted, denied, notDetermined }

abstract class NotificationService {
  Future<NotificationPermission> get permission;

  Future<bool> requestPermission();

  Future<void> showMatchNotification({
    required String matchId,
    required String title,
    required String body,
    String? payload,
  });

  Future<void> showGoalNotification({
    required String matchId,
    required String homeTeam,
    required String awayTeam,
    required String scorer,
    required String score,
  });

  Future<void> showKickoffNotification({
    required String matchId,
    required String homeTeam,
    required String awayTeam,
  });

  Future<void> showRedCardNotification({
    required String matchId,
    required String team,
    required String player,
  });

  Future<void> cancelMatchNotifications(String matchId);

  bool shouldNotify(AppSettings settings, String eventType);
}

extension NotificationSettingsX on AppSettings {
  bool shouldNotifyFor(String eventType) {
    if (!allowNotifications) return false;
    return switch (eventType) {
      'goal' => goalNotifications,
      'redCard' => redCardNotifications,
      'kickoff' => kickoffNotifications,
      _ => false,
    };
  }
}
