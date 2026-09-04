
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../app/shell/app_shell.dart';
import '../../app/shell/app_shell_binding.dart';
import '../../features/calendar/presentation/bindings/day_detail_binding.dart';
import '../../features/calendar/presentation/day_detail/screens/day_detail_screen.dart';
import '../../features/habits/presentation/bindings/create_habit_binding.dart';
import '../../features/habits/presentation/bindings/edit_habit_binding.dart';
import '../../features/habits/presentation/bindings/habit_detail_binding.dart';
import '../../features/habits/presentation/bindings/manage_habits_binding.dart';
import '../../features/habits/presentation/create_habit/screens/create_habit_screen.dart';
import '../../features/habits/presentation/edit_habit/screens/edit_habit_screen.dart';
import '../../features/habits/presentation/habit_detail/screens/habit_detail_screen.dart';
import '../../features/habits/presentation/manage_habits/screens/manage_habits_screen.dart';
import '../../features/onboarding/presentation/bindings/onboarding_preferences_binding.dart';
import '../../features/onboarding/presentation/bindings/splash_binding.dart';
import '../../features/onboarding/presentation/preferences/screens/onboarding_preferences_screen.dart';
import '../../features/onboarding/presentation/splash/screens/splash_screen.dart';
import '../../features/onboarding/presentation/welcome/screens/welcome_screen.dart';
import 'app_routes.dart';

class AppPages {
  // Habitly has no account/login flow (BRD §4.2) — Splash decides between
  // Onboarding (first launch) and the shell (BRD §S01).
  // `lib/features/sample_feature/` (login/reset-PIN) went missing from disk
  // mid-session with no explanation (see memory
  // "habitly-project-overview"); its routes are gone too, which is moot for
  // Habitly since they were never meant to be reachable.
  static const initial = AppRoutes.splash;

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboardingWelcome,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: AppRoutes.onboardingPreferences,
      page: () => const OnboardingPreferencesScreen(),
      binding: OnboardingPreferencesBinding(),
    ),
    GetPage(
      name: AppRoutes.appShell,
      page: () => const AppShell(),
      bindings: [
        AppShellBinding(),
      ],
    ),
    GetPage(
      name: AppRoutes.createHabit,
      page: () => const CreateHabitScreen(),
      binding: CreateHabitBinding(),
    ),
    GetPage(
      name: AppRoutes.habitDetail,
      page: () => const HabitDetailScreen(),
      binding: HabitDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.editHabit,
      page: () => const EditHabitScreen(),
      binding: EditHabitBinding(),
    ),
    GetPage(
      name: AppRoutes.manageHabits,
      page: () => const ManageHabitsScreen(),
      binding: ManageHabitsBinding(),
    ),
    GetPage(
      name: AppRoutes.dayDetail,
      page: () => const DayDetailScreen(),
      binding: DayDetailBinding(),
    ),
  ];
}
