import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../domain/models/app_settings.dart';
import '../domain/services/notification_service.dart';

class LocalNotificationService implements NotificationService {
  LocalNotificationService() {
    _init();
  }

  final _plugin = FlutterLocalNotificationsPlugin();
  int _notificationId = 1000;

  Future<void> _init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings: settings);
  }

  @override
  Future<NotificationPermission> get permission async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      final granted = await android.areNotificationsEnabled();
      if (granted == true) return NotificationPermission.granted;
      return NotificationPermission.notDetermined;
    }

    return NotificationPermission.notDetermined;
  }

  @override
  Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final result = await android.requestNotificationsPermission();
      return result == true;
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final result = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return result == true;
    }

    return true;
  }

  @override
  Future<void> showMatchNotification({
    required String matchId,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _showNotification(title, body, payload: payload);
  }

  @override
  Future<void> showGoalNotification({
    required String matchId,
    required String homeTeam,
    required String awayTeam,
    required String scorer,
    required String score,
  }) async {
    await _showNotification(
      '⚽ 进球！$homeTeam vs $awayTeam',
      '$scorer 破门！当前比分 $score',
      payload: matchId,
    );
  }

  @override
  Future<void> showKickoffNotification({
    required String matchId,
    required String homeTeam,
    required String awayTeam,
  }) async {
    await _showNotification(
      '🔔 比赛开始',
      '$homeTeam vs $awayTeam 已开赛',
      payload: matchId,
    );
  }

  @override
  Future<void> showRedCardNotification({
    required String matchId,
    required String team,
    required String player,
  }) async {
    await _showNotification(
      '🟥 红牌！',
      '$player 被罚下（$team）',
      payload: matchId,
    );
  }

  @override
  Future<void> cancelMatchNotifications(String matchId) async {}

  @override
  bool shouldNotify(AppSettings settings, String eventType) {
    return settings.shouldNotifyFor(eventType);
  }

  Future<void> _showNotification(
    String title,
    String body, {
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'match_events',
      '赛事通知',
      channelDescription: '比赛进球、红牌、开赛提醒',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: _notificationId++,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }
}
