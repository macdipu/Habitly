import 'package:customer/core/data/cache/preference/shared_preference.dart';
import 'package:customer/core/domain/habit/quiet_hours.dart';

/// Global reminder settings (BRD §S22). Uses the same key/value storage the
/// existing theme/locale settings use — Habitly-specific settings that need
/// to travel inside the full-data backup can migrate to the `app_settings`
/// Drift table when Phase 4 backup/export is built (docs/DATA_MODEL.md).
class NotificationSettingsRepository {
  static const _masterEnabledKey = 'notifications:master_enabled';
  static const _quietHoursEnabledKey = 'notifications:quiet_hours_enabled';
  static const _quietHoursStartKey = 'notifications:quiet_hours_start';
  static const _quietHoursEndKey = 'notifications:quiet_hours_end';
  static const _shiftToEndKey = 'notifications:shift_to_quiet_hours_end';

  Future<bool> getMasterEnabled() async {
    final raw = await SharedPreference.getValue(_masterEnabledKey);
    return raw == null ? true : raw.toLowerCase() == 'true';
  }

  Future<void> setMasterEnabled(bool value) => SharedPreference.setBool(_masterEnabledKey, value);

  Future<QuietHours> getQuietHours() async {
    final enabled = await SharedPreference.getBool(_quietHoursEnabledKey);
    final start = await SharedPreference.getValue(_quietHoursStartKey) ?? QuietHours.disabled.start;
    final end = await SharedPreference.getValue(_quietHoursEndKey) ?? QuietHours.disabled.end;
    return QuietHours(enabled: enabled, start: start, end: end);
  }

  Future<void> setQuietHours(QuietHours quietHours) async {
    await SharedPreference.setBool(_quietHoursEnabledKey, quietHours.enabled);
    await SharedPreference.setValue(_quietHoursStartKey, quietHours.start);
    await SharedPreference.setValue(_quietHoursEndKey, quietHours.end);
  }

  /// Whether a quiet-hours-suppressed reminder should instead fire right at
  /// the window's end, same day (docs/SRS.md decision 6's opt-in).
  Future<bool> getShiftToQuietHoursEnd() => SharedPreference.getBool(_shiftToEndKey);

  Future<void> setShiftToQuietHoursEnd(bool value) => SharedPreference.setBool(_shiftToEndKey, value);
}
