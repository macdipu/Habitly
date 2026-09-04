import 'package:customer/core/domain/models/time_format_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/app_settings_repository_impl.dart';
import '../../domain/repositories/app_settings_repository.dart';

/// Mirrors [ThemeController]'s shape/lifecycle. Formats a stored 'HH:mm'
/// string (reminders, quiet hours) per the user's preference (BRD §S03/§16)
/// — the underlying stored value always stays raw 24h 'HH:mm'; only display
/// changes.
class TimeFormatController extends GetxController {
  final AppSettingsRepository _settingsRepository = AppSettingsRepositoryImpl();

  final Rx<AppTimeFormat> format = AppTimeFormat.system.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    try {
      format.value = await _settingsRepository.getTimeFormat();
    } catch (e) {
      debugPrint('Error loading time format: $e');
    }
  }

  Future<void> setFormat(AppTimeFormat value) async {
    format.value = value;
    await _settingsRepository.setTimeFormat(value);
  }

  /// Formats a raw 'HH:mm' string for display. [use24hFallback] is the
  /// device's `MediaQuery.alwaysUse24HourFormat` — consulted only when the
  /// preference is [AppTimeFormat.system].
  String formatTime(String hhmm, {bool use24hFallback = true}) {
    final parts = hhmm.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final mm = minute.toString().padLeft(2, '0');

    final effectivelyH24 = switch (format.value) {
      AppTimeFormat.h24 => true,
      AppTimeFormat.h12 => false,
      AppTimeFormat.system => use24hFallback,
    };

    if (effectivelyH24) return '${hour.toString().padLeft(2, '0')}:$mm';
    final period = hour >= 12 ? 'PM' : 'AM';
    final h12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$h12:$mm $period';
  }
}
