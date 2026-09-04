import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'notification_scheduler.dart';

/// Thin wrapper around `flutter_local_notifications` scoped to Habitly's
/// own reminder channel — deliberately separate from the unrelated
/// Firebase/push plumbing already in this boilerplate
/// (docs/ARCHITECTURE.md §6). Scheduling policy (which dates/times to use,
/// quiet hours) lives in the pure `core/domain/habit` layer; this class
/// only talks to the OS.
class HabitNotificationService implements NotificationScheduler {
  static const _channelId = 'habitly_reminders';
  static const _channelName = 'Habit reminders';
  static const _channelDescription = 'Reminders for your Habitly habits';

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz_data.initializeTimeZones();
    try {
      final localTimezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTimezone));
    } catch (e) {
      // Never block app start on timezone detection — fall back to UTC and
      // let the next successful reconcile correct it (BRD §11.3).
      debugPrint('HabitNotificationService: timezone detection failed: $e');
    }

    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.defaultImportance,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );

    _initialized = true;
  }

  /// Requests OS notification permission. Never call this at habit-save
  /// time without a contextual explanation first (BRD §S03/§S10,
  /// docs/SRS.md FR-53) — denial must never block saving a habit.
  Future<bool> requestPermission() async {
    final androidGranted = await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    if (androidGranted != null) return androidGranted;

    final iosGranted = await _plugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return iosGranted ?? false;
  }

  Future<bool> hasPermission() async {
    final androidEnabled = await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.areNotificationsEnabled();
    if (androidEnabled != null) return androidEnabled;
    // iOS has no direct "is enabled" query pre-permission-request; treat as
    // granted once requestPermission has succeeded (tracked by the caller).
    return true;
  }

  /// Schedules a single reminder fire. Uses `inexactAllowWhileIdle` so no
  /// exact-alarm permission is ever requested (BRD §9, docs/SRS.md FR-54) —
  /// the OS may deliver it with some variance, which the BRD explicitly
  /// tolerates.
  @override
  Future<void> scheduleOneShot({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    if (!_initialized) await init();
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  @override
  Future<void> cancel(int id) async {
    if (!_initialized) await init();
    await _plugin.cancel(id: id);
  }

  @override
  Future<void> cancelAll() async {
    if (!_initialized) await init();
    await _plugin.cancelAll();
  }
}
