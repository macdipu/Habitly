class AppRoutes {
  static const String login = '/login';
  static const String appShell = '/app_shell';
  static const String forgotPin = '/forgot_pin';
  static const String forgotPinOtpVerify = '/forgot_pin_otp_verify';
  static const String resetPin = '/reset_pin';
  static const String resetPinSuccess = '/reset_pin_success';

  // Habitly
  static const String splash = '/splash';
  static const String onboardingWelcome = '/onboarding/welcome';
  static const String onboardingPreferences = '/onboarding/preferences';
  static const String createHabit = '/habits/create';
  static const String habitDetail = '/habits/detail';
  static const String editHabit = '/habits/edit';
  static const String manageHabits = '/habits/manage';
  static const String dayDetail = '/calendar/day';

  // Settings sub-screens (S21/S22/S23/S25) — the main Settings tab (S20) is
  // a home screen of rows navigating into these.
  static const String appearanceSettings = '/settings/appearance';
  static const String calendarSettings = '/settings/calendar';
  static const String notificationSettings = '/settings/notifications';
  static const String dataBackupSettings = '/settings/data-backup';
  static const String privacyAbout = '/settings/privacy-about';
}
