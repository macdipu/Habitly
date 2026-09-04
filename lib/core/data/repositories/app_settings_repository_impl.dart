import 'package:customer/core/domain/models/theme_mode_enum.dart';
import 'package:customer/core/domain/models/time_format_enum.dart';
import 'package:customer/core/domain/repositories/app_settings_repository.dart';
import '../cache/preference/shared_preference.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  static const String _themeKey = 'app_settings:theme_mode';
  static const String _localeKey = 'app_settings:locale';
  static const String _startOfWeekKey = 'app_settings:start_of_week';
  static const String _timeFormatKey = 'app_settings:time_format';
  static const String _onboardingCompleteKey = 'app_settings:onboarding_complete';

  @override
  Future<AppThemeMode> getThemeMode() async {
    try {
      final value = await SharedPreference.getValue(_themeKey);
      if (value == null) {
        return AppThemeMode.system;
      }
      return AppThemeMode.fromString(value);
    } catch (e) {
      return AppThemeMode.system;
    }
  }

  @override
  Future<void> setThemeMode(AppThemeMode mode) async {
    await SharedPreference.setValue(_themeKey, mode.toStringValue());
  }

  @override
  Future<String?> getLocale() async {
    return await SharedPreference.getValue(_localeKey);
  }

  @override
  Future<void> setLocale(String locale) async {
    await SharedPreference.setValue(_localeKey, locale);
  }

  @override
  Future<int> getStartOfWeek() async {
    final value = await SharedPreference.getValue(_startOfWeekKey);
    return int.tryParse(value ?? '') ?? DateTime.monday;
  }

  @override
  Future<void> setStartOfWeek(int isoWeekday) async {
    await SharedPreference.setValue(_startOfWeekKey, isoWeekday.toString());
  }

  @override
  Future<AppTimeFormat> getTimeFormat() async {
    final value = await SharedPreference.getValue(_timeFormatKey);
    if (value == null) return AppTimeFormat.system;
    return AppTimeFormat.fromString(value);
  }

  @override
  Future<void> setTimeFormat(AppTimeFormat format) async {
    await SharedPreference.setValue(_timeFormatKey, format.toStringValue());
  }

  @override
  Future<bool> isOnboardingComplete() async {
    final value = await SharedPreference.getValue(_onboardingCompleteKey);
    return value?.toLowerCase() == 'true';
  }

  @override
  Future<void> setOnboardingComplete(bool value) async {
    await SharedPreference.setBool(_onboardingCompleteKey, value);
  }

  @override
  Future<void> clearSettings() async {
    await SharedPreference.remove(_themeKey);
    await SharedPreference.remove(_localeKey);
    await SharedPreference.remove(_startOfWeekKey);
    await SharedPreference.remove(_timeFormatKey);
    await SharedPreference.remove(_onboardingCompleteKey);
  }
}
