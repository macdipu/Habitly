import '../models/theme_mode_enum.dart';
import '../models/time_format_enum.dart';

abstract class AppSettingsRepository {
  /// Get the current theme mode
  Future<AppThemeMode> getThemeMode();

  /// Save theme mode preference
  Future<void> setThemeMode(AppThemeMode mode);

  /// Get locale preference
  Future<String?> getLocale();

  /// Save locale preference
  Future<void> setLocale(String locale);

  /// ISO weekday the week starts on: 1 = Monday, 7 = Sunday (BRD §S03).
  /// Defaults to Monday.
  Future<int> getStartOfWeek();

  Future<void> setStartOfWeek(int isoWeekday);

  Future<AppTimeFormat> getTimeFormat();

  Future<void> setTimeFormat(AppTimeFormat format);

  /// Whether onboarding (S02/S03) has been completed — the splash screen's
  /// first-launch check (BRD §S01).
  Future<bool> isOnboardingComplete();

  Future<void> setOnboardingComplete(bool value);

  /// Clear all app settings
  Future<void> clearSettings();
}

