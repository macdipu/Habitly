import 'package:customer/services/notifications/notification_scheduler.dart';
import 'package:timezone/timezone.dart' as tz;

sealed class SchedulerCall {}

class ScheduledCall extends SchedulerCall {
  final int id;
  final String title;
  final tz.TZDateTime scheduledDate;
  ScheduledCall(this.id, this.title, this.scheduledDate);
}

class CancelledCall extends SchedulerCall {
  final int id;
  CancelledCall(this.id);
}

/// Records every call in order so tests can assert both *what* was
/// scheduled/cancelled and the *sequence* (cancel-before-reschedule,
/// docs/SRS.md FR-51), without touching the real notification channel.
class FakeNotificationScheduler implements NotificationScheduler {
  final List<SchedulerCall> calls = [];
  final Set<int> activeIds = {};

  @override
  Future<void> scheduleOneShot({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    calls.add(ScheduledCall(id, title, scheduledDate));
    activeIds.add(id);
  }

  @override
  Future<void> cancel(int id) async {
    calls.add(CancelledCall(id));
    activeIds.remove(id);
  }

  @override
  Future<void> cancelAll() async {
    for (final id in activeIds.toList()) {
      calls.add(CancelledCall(id));
    }
    activeIds.clear();
  }
}
