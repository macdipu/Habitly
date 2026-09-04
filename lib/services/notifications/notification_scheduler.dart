import 'package:timezone/timezone.dart' as tz;

/// The subset of [HabitNotificationService] that [ReminderReconciler]
/// needs — split out so the orchestration logic (cancel-before-reschedule,
/// master-toggle/archived/quiet-hours handling) is unit-testable with a
/// fake, without touching the real `flutter_local_notifications` channel.
abstract class NotificationScheduler {
  Future<void> scheduleOneShot({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    // The habitId — carried through to a tap so the app can deep-link
    // straight into that habit's detail screen (BRD §9).
    required String payload,
  });

  Future<void> cancel(int id);

  Future<void> cancelAll();
}
